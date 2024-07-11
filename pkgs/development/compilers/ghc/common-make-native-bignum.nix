{ version
, sha256
, url ? "https://downloads.haskell.org/ghc/${version}/ghc-${version}-src.tar.xz"
}:

{ lib, stdenv, pkgsBuildTarget, pkgsHostTarget, targetPackages

# build-tools
, bootPkgs
, autoconf, automake, coreutils, fetchpatch, fetchurl, perl, python3, m4, sphinx
, xattr, autoSignDarwinBinariesHook
, bash

, libiconv ? null, ncurses
, glibcLocales ? null

, # GHC can be built with system libffi or a bundled one.
  libffi ? null

, useLLVM ? !(stdenv.targetPlatform.isx86
              || stdenv.targetPlatform.isPower
              || stdenv.targetPlatform.isSparc
              || (lib.versionAtLeast version "9.2" && stdenv.targetPlatform.isAarch64))
, # LLVM is conceptually a run-time-only dependency, but for
  # non-x86, we need LLVM to bootstrap later stages, so it becomes a
  # build-time dependency too.
  buildTargetLlvmPackages, llvmPackages

, # If enabled, GHC will be built with the GPL-free but slightly slower native
  # bignum backend instead of the faster but GPLed gmp backend.
  enableNativeBignum ? !(lib.meta.availableOn stdenv.hostPlatform gmp
                         && lib.meta.availableOn stdenv.targetPlatform gmp)
, gmp

, # If enabled, use -fPIC when compiling static libs.
  enableRelocatedStaticLibs ? stdenv.targetPlatform != stdenv.hostPlatform

, enableProfiledLibs ? true

, # Whether to build dynamic libs for the standard library (on the target
  # platform). Static libs are always built.
  enableShared ? with stdenv.targetPlatform; !isWindows && !useiOSPrebuilt && !isStatic

, # Whether to build terminfo.
  enableTerminfo ? !stdenv.targetPlatform.isWindows

, # What flavour to build. An empty string indicates no
  # specific flavour and falls back to ghc default values.
  ghcFlavour ? lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
    (if useLLVM then "perf-cross" else "perf-cross-ncg")

, #  Whether to build sphinx documentation.
  enableDocs ? (
    # Docs disabled if we are building on musl because it's a large task to keep
    # all `sphinx` dependencies building in this environment.
    !stdenv.buildPlatform.isMusl
  )

, enableHaddockProgram ?
    # Disabled for cross; see note [HADDOCK_DOCS].
    (stdenv.targetPlatform == stdenv.hostPlatform)

, # Whether to disable the large address space allocator
  # necessary fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
  disableLargeAddressSpace ? stdenv.targetPlatform.isiOS
}:

assert !enableNativeBignum -> gmp != null;

# Cross cannot currently build the `haddock` program for silly reasons,
# see note [HADDOCK_DOCS].
assert (stdenv.targetPlatform != stdenv.hostPlatform) -> !enableHaddockProgram;

let
  inherit (stdenv) buildPlatform hostPlatform targetPlatform;

  inherit (bootPkgs) ghc;

  # TODO(@Ericson2314) Make unconditional
  targetPrefix = lib.optionalString
    (targetPlatform != hostPlatform)
    "${targetPlatform.config}-";

  buildMK = ''
    BuildFlavour = ${ghcFlavour}
    ifneq \"\$(BuildFlavour)\" \"\"
    include mk/flavours/\$(BuildFlavour).mk
    endif
    BUILD_SPHINX_HTML = ${if enableDocs then "YES" else "NO"}
    BUILD_SPHINX_PDF = NO
  '' +
  # Note [HADDOCK_DOCS]:
  # Unfortunately currently `HADDOCK_DOCS` controls both whether the `haddock`
  # program is built (which we generally always want to have a complete GHC install)
  # and whether it is run on the GHC sources to generate hyperlinked source code
  # (which is impossible for cross-compilation); see:
  # https://gitlab.haskell.org/ghc/ghc/-/issues/20077
  # This implies that currently a cross-compiled GHC will never have a `haddock`
  # program, so it can never generate haddocks for any packages.
  # If this is solved in the future, we'd like to unconditionally
  # build the haddock program (removing the `enableHaddockProgram` option).
  ''
    HADDOCK_DOCS = ${if enableHaddockProgram then "YES" else "NO"}
    # Build haddocks for boot packages with hyperlinking
    EXTRA_HADDOCK_OPTS += --hyperlinked-source --quickjump

    DYNAMIC_GHC_PROGRAMS = ${if enableShared then "YES" else "NO"}
    BIGNUM_BACKEND = ${if enableNativeBignum then "native" else "gmp"}
  '' + lib.optionalString (targetPlatform != hostPlatform) ''
    Stage1Only = ${if targetPlatform.system == hostPlatform.system then "NO" else "YES"}
    CrossCompilePrefix = ${targetPrefix}
  '' + lib.optionalString (!enableProfiledLibs) ''
    BUILD_PROF_LIBS = NO
  '' +
  # -fexternal-dynamic-refs apparently (because it's not clear from the documentation)
  # makes the GHC RTS able to load static libraries, which may be needed for TemplateHaskell.
  # This solution was described in https://www.tweag.io/blog/2020-09-30-bazel-static-haskell
  lib.optionalString enableRelocatedStaticLibs ''
    GhcLibHcOpts += -fPIC -fexternal-dynamic-refs
    GhcRtsHcOpts += -fPIC -fexternal-dynamic-refs
  '' + lib.optionalString targetPlatform.useAndroidPrebuilt ''
    EXTRA_CC_OPTS += -std=gnu99
  '';

  # Splicer will pull out correct variations
  libDeps = platform: lib.optional enableTerminfo ncurses
    ++ [libffi]
    ++ lib.optional (!enableNativeBignum) gmp
    ++ lib.optional (platform.libc != "glibc" && !targetPlatform.isWindows) libiconv;

  # TODO(@sternenseemann): is buildTarget LLVM unnecessary?
  # GHC doesn't seem to have {LLC,OPT}_HOST
  toolsForTarget = [
    pkgsBuildTarget.targetPackages.stdenv.cc
  ] ++ lib.optional useLLVM buildTargetLlvmPackages.llvm;

  targetCC = builtins.head toolsForTarget;

  # Sometimes we have to dispatch between the bintools wrapper and the unwrapped
  # derivation for certain tools depending on the platform.
  bintoolsFor = {
    # GHC needs install_name_tool on all darwin platforms. On aarch64-darwin it is
    # part of the bintools wrapper (due to codesigning requirements), but not on
    # x86_64-darwin.
    install_name_tool =
      if stdenv.targetPlatform.isAarch64
      then targetCC.bintools
      else targetCC.bintools.bintools;
    # Same goes for strip.
    strip =
      # TODO(@sternenseemann): also use wrapper if linker == "bfd" or "gold"
      if stdenv.targetPlatform.isAarch64 && stdenv.targetPlatform.isDarwin
      then targetCC.bintools
      else targetCC.bintools.bintools;
  };

  # Use gold either following the default, or to avoid the BFD linker due to some bugs / perf issues.
  # But we cannot avoid BFD when using musl libc due to https://sourceware.org/bugzilla/show_bug.cgi?id=23856
  # see #84670 and #49071 for more background.
  useLdGold = targetPlatform.linker == "gold" ||
    (targetPlatform.linker == "bfd" && (targetCC.bintools.bintools.hasGold or false) && !targetPlatform.isMusl);

  # Makes debugging easier to see which variant is at play in `nix-store -q --tree`.
  variantSuffix = lib.concatStrings [
    (lib.optionalString stdenv.hostPlatform.isMusl "-musl")
    (lib.optionalString enableNativeBignum "-native-bignum")
  ];

in

# C compiler, bintools and LLVM are used at build time, but will also leak into
# the resulting GHC's settings file and used at runtime. This means that we are
# currently only able to build GHC if hostPlatform == buildPlatform.
assert targetCC == pkgsHostTarget.targetPackages.stdenv.cc;
assert buildTargetLlvmPackages.llvm == llvmPackages.llvm;
assert stdenv.targetPlatform.isDarwin -> buildTargetLlvmPackages.clang == llvmPackages.clang;

stdenv.mkDerivation (rec {
  pname = "${targetPrefix}ghc${variantSuffix}";
  inherit version;

  src = fetchurl {
    inherit url sha256;
  };

  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  patches = lib.optionals (lib.versionOlder version "9.4") [
    # fix hyperlinked haddock sources: https://github.com/haskell/haddock/pull/1482
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/haskell/haddock/pull/1482.patch";
      sha256 = "sha256-8w8QUCsODaTvknCDGgTfFNZa8ZmvIKaKS+2ZJZ9foYk=";
      extraPrefix = "utils/haddock/";
      stripLen = 1;
    })
  ]

  ++ lib.optionals (lib.versionOlder version "9.4.6") [
    # Fix docs build with sphinx >= 6.0
    # https://gitlab.haskell.org/ghc/ghc/-/issues/22766
    (fetchpatch {
      name = "ghc-docs-sphinx-6.0.patch";
      url = "https://gitlab.haskell.org/ghc/ghc/-/commit/10e94a556b4f90769b7fd718b9790d58ae566600.patch";
      sha256 = "0kmhfamr16w8gch0lgln2912r8aryjky1hfcda3jkcwa5cdzgjdv";
    })
  ]

  ++ [
    # Fix docs build with Sphinx >= 7 https://gitlab.haskell.org/ghc/ghc/-/issues/24129
    ./docs-sphinx-7.patch
  ]

  ++ lib.optionals (lib.versionOlder version "9.2.2") [
    # Add flag that fixes C++ exception handling; opt-in. Merged in 9.4 and 9.2.2.
    # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/7423
    (fetchpatch {
      name = "ghc-9.0.2-fcompact-unwind.patch";
      # Note that the test suite is not packaged.
      url = "https://gitlab.haskell.org/ghc/ghc/-/commit/c6132c782d974a7701e7f6447bdcd2bf6db4299a.patch?merge_request_iid=7423";
      sha256 = "sha256-b4feGZIaKDj/UKjWTNY6/jH4s2iate0wAgMxG3rAbZI=";
    })
  ]

  ++ lib.optionals (lib.versionAtLeast version "9.2") [
    # Don't generate code that doesn't compile when --enable-relocatable is passed to Setup.hs
    # Can be removed if the Cabal library included with ghc backports the linked fix
    (fetchpatch {
      url = "https://github.com/haskell/cabal/commit/6c796218c92f93c95e94d5ec2d077f6956f68e98.patch";
      stripLen = 1;
      extraPrefix = "libraries/Cabal/";
      sha256 = "sha256-yRQ6YmMiwBwiYseC5BsrEtDgFbWvst+maGgDtdD0vAY=";
    })
  ]

  ++ lib.optionals (version == "9.4.6") [
    # Work around a type not being defined when including Rts.h in bytestring's cbits
    # due to missing feature macros. See https://gitlab.haskell.org/ghc/ghc/-/issues/23810.
    ./9.4.6-bytestring-posix-source.patch
  ]

  ++ lib.optionals (stdenv.targetPlatform.isDarwin && stdenv.targetPlatform.isAarch64) [
    # Prevent the paths module from emitting symbols that we don't use
    # when building with separate outputs.
    #
    # These cause problems as they're not eliminated by GHC's dead code
    # elimination on aarch64-darwin. (see
    # https://github.com/NixOS/nixpkgs/issues/140774 for details).
    (if lib.versionAtLeast version "9.2"
     then ./Cabal-at-least-3.6-paths-fix-cycle-aarch64-darwin.patch
     else ./Cabal-3.2-3.4-paths-fix-cycle-aarch64-darwin.patch)
  ];

  postPatch = "patchShebangs .";

  # GHC needs the locale configured during the Haddock phase.
  LANG = "en_US.UTF-8";

  # GHC is a bit confused on its cross terminology.
  # TODO(@sternenseemann): investigate coreutils dependencies and pass absolute paths
  preConfigure = ''
    for env in $(env | grep '^TARGET_' | sed -E 's|\+?=.*||'); do
      export "''${env#TARGET_}=''${!env}"
    done
    # GHC is a bit confused on its cross terminology, as these would normally be
    # the *host* tools.
    export CC="${targetCC}/bin/${targetCC.targetPrefix}cc"
    export CXX="${targetCC}/bin/${targetCC.targetPrefix}c++"
    # Use gold to work around https://sourceware.org/bugzilla/show_bug.cgi?id=16177
    export LD="${targetCC.bintools}/bin/${targetCC.bintools.targetPrefix}ld${lib.optionalString useLdGold ".gold"}"
    export AS="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}as"
    export AR="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}ar"
    export NM="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}nm"
    export RANLIB="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}ranlib"
    export READELF="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}readelf"
    export STRIP="${bintoolsFor.strip}/bin/${bintoolsFor.strip.targetPrefix}strip"
  '' + lib.optionalString (stdenv.targetPlatform.linker == "cctools") ''
    export OTOOL="${targetCC.bintools.bintools}/bin/${targetCC.bintools.targetPrefix}otool"
    export INSTALL_NAME_TOOL="${bintoolsFor.install_name_tool}/bin/${bintoolsFor.install_name_tool.targetPrefix}install_name_tool"
  '' + lib.optionalString useLLVM ''
    export LLC="${lib.getBin buildTargetLlvmPackages.llvm}/bin/llc"
    export OPT="${lib.getBin buildTargetLlvmPackages.llvm}/bin/opt"
  '' + lib.optionalString (useLLVM && stdenv.targetPlatform.isDarwin) ''
    # LLVM backend on Darwin needs clang: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/codegens.html#llvm-code-generator-fllvm
    export CLANG="${buildTargetLlvmPackages.clang}/bin/${buildTargetLlvmPackages.clang.targetPrefix}clang"
  ''
  + ''
    echo -n "${buildMK}" > mk/build.mk
  ''
  + lib.optionalString (lib.versionOlder version "9.2" || lib.versionAtLeast version "9.4") ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + lib.optionalString (stdenv.isLinux && hostPlatform.libc == "glibc") ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '' + lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
  '' + lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '' + lib.optionalString (stdenv.isDarwin && lib.versionAtLeast version "9.2") ''

    # GHC tries the host xattr /usr/bin/xattr by default which fails since it expects python to be 2.7
    export XATTR=${lib.getBin xattr}/bin/xattr
  '' + lib.optionalString targetPlatform.useAndroidPrebuilt ''
    sed -i -e '5i ,("armv7a-unknown-linux-androideabi", ("e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64", "cortex-a8", ""))' llvm-targets
  '' + lib.optionalString targetPlatform.isMusl ''
      echo "patching llvm-targets for musl targets..."
      echo "Cloning these existing '*-linux-gnu*' targets:"
      grep linux-gnu llvm-targets | sed 's/^/  /'
      echo "(go go gadget sed)"
      sed -i 's,\(^.*linux-\)gnu\(.*\)$,\0\n\1musl\2,' llvm-targets
      echo "llvm-targets now contains these '*-linux-musl*' targets:"
      grep linux-musl llvm-targets | sed 's/^/  /'

      echo "And now patching to preserve '-musleabi' as done with '-gnueabi'"
      # (aclocal.m4 is actual source, but patch configure as well since we don't re-gen)
      for x in configure aclocal.m4; do
        substituteInPlace $x \
          --replace '*-android*|*-gnueabi*)' \
                    '*-android*|*-gnueabi*|*-musleabi*)'
      done
  ''
  # HACK: allow bootstrapping with GHC 8.10 which works fine, as we don't have
  # binary 9.0 packaged. Bootstrapping with 9.2 is broken without hadrian.
  + lib.optionalString (lib.versions.majorMinor version == "9.4") ''
    substituteInPlace configure --replace \
      'MinBootGhcVersion="9.0"' \
      'MinBootGhcVersion="8.10"'
  '';

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ]
    ++ lib.optional (targetPlatform != hostPlatform) "target";

  # `--with` flags for libraries needed for RTS linker
  configureFlags = [
    "--datadir=$doc/share/doc/ghc"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
  ] ++ lib.optionals (libffi != null) [
    "--with-system-libffi"
    "--with-ffi-includes=${targetPackages.libffi.dev}/include"
    "--with-ffi-libraries=${targetPackages.libffi.out}/lib"
  ] ++ lib.optionals (targetPlatform == hostPlatform && !enableNativeBignum) [
    "--with-gmp-includes=${targetPackages.gmp.dev}/include"
    "--with-gmp-libraries=${targetPackages.gmp.out}/lib"
  ] ++ lib.optionals (targetPlatform == hostPlatform && hostPlatform.libc != "glibc" && !targetPlatform.isWindows) [
    "--with-iconv-includes=${libiconv}/include"
    "--with-iconv-libraries=${libiconv}/lib"
  ] ++ lib.optionals (targetPlatform != hostPlatform) [
    "--enable-bootstrap-with-devel-snapshot"
  ] ++ lib.optionals useLdGold [
    "CFLAGS=-fuse-ld=gold"
    "CONF_GCC_LINKER_OPTS_STAGE1=-fuse-ld=gold"
    "CONF_GCC_LINKER_OPTS_STAGE2=-fuse-ld=gold"
  ] ++ lib.optionals (disableLargeAddressSpace) [
    "--disable-large-address-space"
  ];

  # Make sure we never relax`$PATH` and hooks support for compatibility.
  strictDeps = true;

  # Don’t add -liconv to LDFLAGS automatically so that GHC will add it itself.
  dontAddExtraLibs = true;

  nativeBuildInputs = [
    perl autoconf automake m4 python3
    ghc bootPkgs.alex bootPkgs.happy bootPkgs.hscolour
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    autoSignDarwinBinariesHook
  ] ++ lib.optionals enableDocs [
    sphinx
  ] ++ lib.optionals (stdenv.isDarwin && lib.versions.majorMinor version == "9.0") [
    # TODO(@sternenseemann): backport addition of XATTR env var like
    # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/6447
    xattr
  ];

  # For building runtime libs
  depsBuildTarget = toolsForTarget;

  buildInputs = [ perl bash ] ++ (libDeps hostPlatform);

  depsTargetTarget = map lib.getDev (libDeps targetPlatform);
  depsTargetTargetPropagated = map (lib.getOutput "out") (libDeps targetPlatform);

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ lib.optional (!targetPlatform.isDarwin) "--keep-file-symbols";

  checkTarget = "test";

  hardeningDisable =
    [ "format" ]
    # In nixpkgs, musl based builds currently enable `pie` hardening by default
    # (see `defaultHardeningFlags` in `make-derivation.nix`).
    # But GHC cannot currently produce outputs that are ready for `-pie` linking.
    # Thus, disable `pie` hardening, otherwise `recompile with -fPIE` errors appear.
    # See:
    # * https://github.com/NixOS/nixpkgs/issues/129247
    # * https://gitlab.haskell.org/ghc/ghc/-/issues/19580
    ++ lib.optional stdenv.targetPlatform.isMusl "pie";

  # big-parallel allows us to build with more than 2 cores on
  # Hydra which already warrants a significant speedup
  requiredSystemFeatures = [ "big-parallel" ];

  postInstall = ''
    # Install the bash completion file.
    install -D -m 444 utils/completion/ghc.bash $out/share/bash-completion/completions/${targetPrefix}ghc
  '';

  passthru = {
    inherit bootPkgs targetPrefix;

    inherit llvmPackages;
    inherit enableShared;

    # This is used by the haskell builder to query
    # the presence of the haddock program.
    hasHaddock = enableHaddockProgram;

    # Our Cabal compiler name
    haskellCompilerName = "ghc-${version}";
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "Glasgow Haskell Compiler";
    maintainers = with lib.maintainers; [
      guibou
    ] ++ lib.teams.haskell.members;
    timeout = 24 * 3600;
    inherit (ghc.meta) license platforms;
  };

} // lib.optionalAttrs targetPlatform.useAndroidPrebuilt {
  dontStrip = true;
  dontPatchELF = true;
  noAuditTmpdir = true;
})
