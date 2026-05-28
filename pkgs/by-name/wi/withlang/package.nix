{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,

  darwin, # darwin.DarwinTools provides sw_vers
  libxml2,
  llvmPackages_22, # seed binary uses LLVM 22 APIs
  nix-update-script,
  runCommandCC,
  symlinkJoin,
  zig,
  zlib,
  zstd,
}:

let
  llvmPackages = llvmPackages_22;

  # build hard-requires LLVM_PREFIX/lib/libclang.a (static).
  libclangStatic = llvmPackages.libclang.override {
    devExtraCmakeFlags = [ (lib.cmakeBool "LIBCLANG_BUILD_STATIC" true) ];
  };

  # Build variants that produce static archives alongside the shared libs:
  # - libxml2 with enableStatic = true exposes libxml2.a in the 'static' output.
  # - zstd with enableStatic = true builds libzstd.a in the default 'out' output.
  # - zlib already ships libz.a in its 'static' output.
  libxml2Static = libxml2.override { enableStatic = true; };
  zstdStatic = zstd.override { enableStatic = true; };

  # Inject static archives into the LLVM link RSP so libLLVM*.a's
  # references to compress2/uncompress/crc32/xml* resolve at link time.
  # Inject absolute static archive paths immediately before -lm
  # so that ld64.lld resolves zlib/zstd/libxml2 symbols pulled in from libLLVM*.a
  # statically (no dynamic library dependency in the final binary).
  # The build/compiler.w generator does not emit -lz/-lzstd/-lxml2
  # because upstream expects a static LLVM SDK built without those features;
  # nixpkgs LLVM has them enabled, so we patch them in.
  linkRSPinjection = lib.concatStringsSep "\\n" [
    "${zlib.static}/lib/libz.a"
    "${zstdStatic.out}/lib/libzstd.a" # lib.getLib resolves to 'bin' output
    "${libxml2Static.static}/lib/libxml2.a"
    "-L${lib.getLib llvmPackages.libcxx}/lib" # -L for libcxx so the unwrapped ld64.lld can resolve -lc++
    "-lm"
  ];

  # The build graph expects a single LLVM_PREFIX with bin/, lib/, and include/.
  # In nixpkgs, clang, llvm, lld, and libclang are split across separate store paths.
  llvmPrefix = symlinkJoin {
    name = "llvm-prefix-for-withlang";
    paths = with llvmPackages; [
      clang-unwrapped # bin/clang
      lld # bin/lld, bin/ld64.lld
      llvm.dev # bin/llvm-config, include/
      llvm # bin/llc, bin/opt etc.
      llvm.lib # lib/libLLVM*.a static archives
      libclangStatic.lib # lib/libclang.a + libclang.dylib + libclang*.a
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "withlang";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "withlang-dev";
    repo = "with";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XarOOsHnCIJxJdZaPt9AaCnrL6ADkGZHoFxZNlPYSnw=";
  };

  nativeBuildInputs = [
    llvmPackages.lld # -fuse-ld=lld for linking compiler stages
    makeWrapper # wrap bin/with with LLVM_PREFIX so the shipped binary works standalone
    zig # emit-c test compiles emitted C with 'zig cc'
  ];

  # 'with' invokes the unwrapped clang from LLVM_PREFIX/bin/clang to link user programs.
  # That clang needs cc-wrapper's setup-hook (and the apple-sdk it transitively propagates)
  # to find SDKROOT and friends.
  propagatedNativeBuildInputs = [ llvmPackages.clang ];

  # libcxx needed so ld64.lld resolves the bare -lc++ that build/compiler.w emits.
  # Static libraries are injected via postPatch.
  buildInputs = [
    llvmPackages.libcxx
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # Makefile uses a serial lock; parallel make will deadlock.
  enableParallelBuilding = false;

  # zig is a build dependency for the emit-c test ('zig cc');
  # we don't want zig's setup-hook to replace make build/check/install phases.
  # zigConfigurePhase is left enabled to set ZIG_GLOBAL_CACHE_DIR for 'zig cc'.
  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  # Upstream Makefile's first target is $(OUT_TMP_DIR), not 'all';
  # so 'make' with no target builds nothing useful: spell out targets.
  buildFlags = [ "build" ];

  postPatch = ''
    substituteInPlace build/compiler.w --replace-fail \
      'rsp = rsp ++ "-lm\n"' \
      'rsp = rsp ++ "${linkRSPinjection}\n"'
    substituteInPlace build/compiler.w --replace-fail \
      'ld_rsp = ld_rsp ++ "-lm\n"' \
      'ld_rsp = ld_rsp ++ "${linkRSPinjection}\n"'
  '';

  postUnpack = ''
    # The compiler emits objects via LLVMGetDefaultTargetTriple;
    # on Darwin this embeds the host's kernel version (e.g. darwin24.6.0)
    # and ignores MACOSX_DEPLOYMENT_TARGET:
    # set our deployment target to the build host's macOS version so ld does
    # not warn about a mismatch (and break tests that match stderr exactly).
    export MACOSX_DEPLOYMENT_TARGET=$(${lib.getExe' darwin.DarwinTools "sw_vers"} -productVersion)
    install -m0755 ${finalAttrs.passthru.seedBin} $sourceRoot/src/main
  '';

  preBuild = ''
    export LLVM_PREFIX="${llvmPrefix}"
    export WITH_VERSION="v${finalAttrs.version}" # TODO: remove when rectified
    export HOME=$(mktemp -d) # compiler clears ~/.cache/with during stage transitions
  '';

  doCheck = true;
  checkTarget = "test"; # full test suite

  # Upstream BuildGraphOps.w reads PREFIX (defaults to /usr/local).
  installFlags = [ "PREFIX=$(out)" ];

  # Match upstream's release packaging gate (scripts/package-darwin-aarch64.sh):
  # the produced binary must not load clang/LLVM/libz/libxml2/zstd dynamically.
  # Run before fixup so we inspect the unwrapped Mach-O binary.
  postInstall = ''
    if otool -L $out/bin/with | grep -E 'clang|LLVM|libz|libxml2|zstd' >/dev/null 2>&1; then
      echo "FAIL: $out/bin/with has forbidden dynamic dependencies:" >&2
      otool -L $out/bin/with >&2
      exit 1
    fi
  '';

  # Wrap so the shipped 'with' resolves clang/lld via our LLVM tree by default.
  # End users can still override with WITH_LLVM_CC or LLVM_PREFIX in their own environment.
  postFixup = ''
    wrapProgram $out/bin/with --set-default LLVM_PREFIX "${llvmPrefix}"
  '';

  passthru = {
    updateScript = nix-update-script { };

    # Seed binary: pre-built aarch64-darwin compiler used to bootstrap stage1.
    seedBin = fetchurl {
      url = "https://github.com/withlang-dev/with/releases/download/v${finalAttrs.version}/with-darwin-aarch64";
      hash = "sha256-G0/3A1rr1isqWPc5Whbf8+O1q+ON8bkEQeenknbchL8=";
    };

    # 'with -e' compiles and runs the snippet as a top-level statement.
    tests.smoke = runCommandCC "${finalAttrs.pname}-smoke-test" { } ''
      # TODO: remove 2>/dev/null when upstream:
      # - stops attempting to write .a files into the install prefix
      # - emits objects whose macOS minos doesn't mismatch the link target
      ${lib.getExe finalAttrs.finalPackage} -e 'print("hello, with")' 2>/dev/null >$out
      diff $out <(echo "hello, with")
    '';
  };

  meta = {
    description = "Systems programming language with a self-hosted compiler";
    homepage = "https://github.com/withlang-dev/with";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siriobalmelli ];
    mainProgram = "with";
    platforms = [ "aarch64-darwin" ]; # TODO: extend as upstream ships platform support
  };
})
