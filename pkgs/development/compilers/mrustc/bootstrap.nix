{
  lib,
  stdenv,
  fetchurl,
  mrustc,
  mrustc-minicargo,
  llvmPackages_21,
  libffi,
  cmake,
  perl,
  python3,
  zlib,
  libxml2,
  pkg-config,
  curl,
  which,
  time,
}:

let
  # rustc 1.90 builds against LLVM 21, so the codegen backend is pinned to
  # llvmPackages_21 explicitly. This currently coincides with the Nixpkgs
  # default `llvmPackages`, but the pin is deliberate and must not be assumed to
  # track that default: when the default moves ahead, this should stay on
  # whatever LLVM the targeted rustc supports (bump it together with
  # `rustcVersion`). mrustc builds rustc's LLVM codegen backend (minicargo
  # `--features llvm`), so it needs a working llvm-config at build time and links
  # libLLVM at runtime. Use a shared libLLVM, mirroring rust/1_95.nix's
  # `llvmSharedFor`.
  llvmShared = llvmPackages_21.libllvm.override { enableSharedLibraries = true; };

  # mrustc v0.12.0 is tested upstream to fully bootstrap rustc 1.90.0; the mrustc
  # README phrases this as "fully bootstrap (with a binary-equal 1.91.1) version
  # 1.90.0". To verify that assertion: build rustc 1.90.0 with mrustc, use that
  # rustc to build rustc 1.91.1 from source, and check the result is bit-
  # identical to the official 1.91.1 release (the comparison mrustc's own
  # bootstrap tests run; the same chain is exercised by dtolnay/bootstrap). Note
  # this derivation does NOT itself depend on bit-identity -- the rustc it
  # produces differs from the binary toolchain by construction (e.g. it reports
  # "built from a source tarball"); the upstream reproduction is only what gives
  # confidence mrustc compiles rustc faithfully. The per-version source patch
  # `rustc-1.90.0-src.patch` and `rustc-1.90.0-overrides.toml` ship in the
  # mrustc tree and are applied/used by the build below.
  mrustcTargetVersion = "1.90";
  rustcVersion = "1.90.0";
  rustcSrc = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${rustcVersion}-src.tar.gz";
    hash = "sha256-eZqfnLpO1TUeBxBIvPa1VgdV2QCWSN7zOkB91JYfm34=";
  };
  rustcDir = "rustc-${rustcVersion}-src";
  outputDir = "output-${rustcVersion}";
in

stdenv.mkDerivation rec {
  pname = "mrustc-bootstrap";
  version = "${mrustc.version}_${rustcVersion}";

  inherit (mrustc) src;
  postUnpack = "tar -xf ${rustcSrc} -C source/";

  # the rust build system complains that nix alters the checksums
  dontFixLibtool = true;

  patches = [
    ./patches/0001-dont-download-rustc.patch
  ];

  postPatch = ''
    echo "applying patch ./rustc-${rustcVersion}-src.patch"
    patch -p0 -d ${rustcDir}/ < rustc-${rustcVersion}-src.patch
  '';

  # rustc unfortunately needs cmake to compile llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    mrustc
    mrustc-minicargo
    perl
    pkg-config
    python3
    time
    which
  ];
  buildInputs = [
    # for rustc
    llvmShared.lib
    libffi
    zlib
    libxml2
    # for cargo
    curl
  ];

  makeFlags = [
    # Use shared mrustc/minicargo/llvm instead of rebuilding them
    "MRUSTC=${mrustc}/bin/mrustc"
    # minicargo is intentionally NOT passed: it is rebuilt in-tree so that
    # `--manifest-overrides rustc-1.90.0-overrides.toml` is honoured.
    #"MINICARGO=${mrustc-minicargo}/bin/minicargo"
    # Point at our LLVM so mrustc does not try to build rustc's vendored LLVM
    # via cmake (which dontUseCmakeConfigure would break). Because this is an
    # existing store path, Make treats the prerequisite as satisfied.
    "LLVM_CONFIG=${llvmShared.dev}/bin/llvm-config"
    "RUSTC_TARGET=${stdenv.targetPlatform.rust.rustcTarget}"
  ];

  buildPhase = ''
    runHook preBuild

    local flagsArray=(
      PARLEVEL=$NIX_BUILD_CORES
      ${toString makeFlags}
    )

    touch ${rustcDir}/dl-version
    export OUTDIR_SUF=-${rustcVersion}
    export RUSTC_VERSION=${rustcVersion}
    export MRUSTC_TARGET_VER=${mrustcTargetVersion}
    export MRUSTC_PATH=${mrustc}/bin/mrustc

    echo minicargo.mk: libs
    make -f minicargo.mk "''${flagsArray[@]}" LIBS

    echo test
    make "''${flagsArray[@]}" test

    # disabled because it expects ./bin/mrustc
    #echo local_tests
    #make "''${flagsArray[@]}" local_tests

    echo minicargo.mk: rustc
    make -f minicargo.mk "''${flagsArray[@]}" ${outputDir}/rustc

    echo minicargo.mk: cargo
    make -f minicargo.mk "''${flagsArray[@]}" ${outputDir}/cargo

    echo run_rustc
    make -C run_rustc "''${flagsArray[@]}"

    unset flagsArray

    runHook postBuild
  '';

  # Bootstrapping rustc 1.90 through mrustc is a multi-hour, many-GB build.
  requiredSystemFeatures = [ "big-parallel" ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    # samples/hello.rs prints "Hello, world!"; match case-insensitively and
    # echo the output so the smoke test is debuggable.
    run_rustc/${outputDir}/prefix/bin/hello_world | tee /dev/stderr | grep -iF "hello, world"
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/ $out/lib/
    cp run_rustc/${outputDir}/prefix/bin/cargo $out/bin/cargo
    cp run_rustc/${outputDir}/prefix/bin/rustc_binary $out/bin/rustc

    cp -r run_rustc/${outputDir}/prefix/lib/* $out/lib/
    cp $out/lib/rustlib/${stdenv.targetPlatform.rust.rustcTarget}/lib/*.so $out/lib/
    runHook postInstall
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "Minimal build of Rust";
    longDescription = ''
      A minimal build of Rust, built from source using mrustc.
      This is useful for bootstrapping the main Rust compiler without
      an initial binary toolchain download.
    '';
    maintainers = with lib.maintainers; [
      progval
      r-burns
    ];
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = [ "x86_64-linux" ];
  };
}
