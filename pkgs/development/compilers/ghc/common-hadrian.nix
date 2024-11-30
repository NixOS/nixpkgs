{ version
, rev ? null
, sha256
, url ?
    if rev != null
    then "https://gitlab.haskell.org/ghc/ghc.git"
    else "https://downloads.haskell.org/ghc/${version}/ghc-${version}-src.tar.xz"
, postFetch ? null
}:

{ lib
, stdenv
, stdenvNoCC
, pkgsBuildTarget
, pkgsHostTarget
, buildPackages
, targetPackages
, fetchpatch

# build-tools
, bootPkgs
, autoconf
, automake
, coreutils
, fetchurl
, fetchgit
, perl
, python3
, m4
, sphinx
, xattr
, autoSignDarwinBinariesHook
, bash
, srcOnly

, libiconv ? null, ncurses
, glibcLocales ? null

, # GHC can be built with system libffi or a bundled one.
  libffi ? null

, useLLVM ? !(stdenv.targetPlatform.isx86
              || stdenv.targetPlatform.isPower
              || stdenv.targetPlatform.isSparc
              || stdenv.targetPlatform.isAarch64
              || stdenv.targetPlatform.isGhcjs)
, # LLVM is conceptually a run-time-only dependency, but for
  # non-x86, we need LLVM to bootstrap later stages, so it becomes a
  # build-time dependency too.
  buildTargetLlvmPackages
, llvmPackages

, # If enabled, GHC will be built with the GPL-free but slightly slower native
  # bignum backend instead of the faster but GPLed gmp backend.
  enableNativeBignum ? !(lib.meta.availableOn stdenv.hostPlatform gmp
                         && lib.meta.availableOn stdenv.targetPlatform gmp)
                       || stdenv.targetPlatform.isGhcjs
, gmp

, # If enabled, use -fPIC when compiling static libs.
  enableRelocatedStaticLibs ? stdenv.targetPlatform != stdenv.hostPlatform

  # Exceeds Hydra output limit (at the time of writing ~3GB) when cross compiled to riscv64.
  # A riscv64 cross-compiler fits into the limit comfortably.
, enableProfiledLibs ? !stdenv.hostPlatform.isRiscV64

, # Whether to build dynamic libs for the standard library (on the target
  # platform). Static libs are always built.
  enableShared ? with stdenv.targetPlatform; !isWindows && !useiOSPrebuilt && !isStatic && !isGhcjs

, # Whether to build terminfo.
  # FIXME(@sternenseemann): This actually doesn't influence what hadrian does,
  # just what buildInputs etc. looks like. It would be best if we could actually
  # tell it what to do like it was possible with make.
  enableTerminfo ? !(stdenv.targetPlatform.isWindows
                     || stdenv.targetPlatform.isGhcjs
                     # terminfo can't be built for cross
                     || (stdenv.buildPlatform != stdenv.hostPlatform)
                     || (stdenv.hostPlatform != stdenv.targetPlatform))

, # Libdw.c only supports x86_64, i686 and s390x as of 2022-08-04
  enableDwarf ? (stdenv.targetPlatform.isx86 ||
                 (stdenv.targetPlatform.isS390 && stdenv.targetPlatform.is64bit)) &&
                lib.meta.availableOn stdenv.hostPlatform elfutils &&
                lib.meta.availableOn stdenv.targetPlatform elfutils &&
                # HACK: elfutils is marked as broken on static platforms
                # which availableOn can't tell.
                !stdenv.targetPlatform.isStatic &&
                !stdenv.hostPlatform.isStatic
, elfutils

, # What flavour to build. Flavour string may contain a flavour and flavour
  # transformers as accepted by hadrian.
  ghcFlavour ?
    let
      # TODO(@sternenseemann): does using the static flavour make sense?
      baseFlavour = "release";
      # Note: in case hadrian's flavour transformers cease being expressive
      # enough for us, we'll need to resort to defining a "nixpkgs" flavour
      # in hadrianUserSettings and using that instead.
      transformers =
        lib.optionals useLLVM [ "llvm" ]
        ++ lib.optionals (!enableShared) [
          "no_dynamic_libs"
          "no_dynamic_ghc"
        ]
        ++ lib.optionals (!enableProfiledLibs) [ "no_profiled_libs" ]
        # While split sections are now enabled by default in ghc 8.8 for windows,
        # they seem to lead to `too many sections` errors when building base for
        # profiling.
        ++ lib.optionals (!stdenv.targetPlatform.isWindows) [ "split_sections" ]
      ;
    in
      baseFlavour + lib.concatMapStrings (t: "+${t}") transformers

, # Contents of the UserSettings.hs file to use when compiling hadrian.
  hadrianUserSettings ? ''
    module UserSettings (
        userFlavours, userPackages, userDefaultFlavour,
        verboseCommand, buildProgressColour, successColour, finalStage
        ) where

    import Flavour.Type
    import Expression
    import {-# SOURCE #-} Settings.Default

    -- no way to set this via the command line
    finalStage :: Stage
    finalStage = ${
      # Always build the stage 2 compiler if possible.
      # TODO(@sternensemann): unify condition with make-built GHCs
      if stdenv.hostPlatform.canExecute stdenv.targetPlatform
      then "Stage2" # native compiler or “native” cross e.g. pkgsStatic
      else "Stage1" # cross compiler
    }

    userDefaultFlavour :: String
    userDefaultFlavour = "release"

    userFlavours :: [Flavour]
    userFlavours = []

    -- Disable Colours
    buildProgressColour :: BuildProgressColour
    buildProgressColour = mkBuildProgressColour (Dull Reset)
    successColour :: SuccessColour
    successColour = mkSuccessColour (Dull Reset)

    -- taken from src/UserSettings.hs unchanged, need to be there
    userPackages :: [Package]
    userPackages = []
    verboseCommand :: Predicate
    verboseCommand = do
        verbosity <- expr getVerbosity
        return $ verbosity >= Verbose
  ''

, ghcSrc ?
    srcOnly {
      name = "ghc-${version}"; # -source appended by srcOnly
      src =
        (if rev != null then fetchgit else fetchurl) ({
          inherit url sha256;
        } // lib.optionalAttrs (rev != null) {
          inherit rev;
        } // lib.optionalAttrs (postFetch != null) {
          inherit postFetch;
        });

      patches =
        let
          enableHyperlinkedSource =
            # Disable haddock generating pretty source listings to stay under 3GB on aarch64-linux
            !(stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux)
            # 9.8 and 9.10 don't run into this problem for some reason
            || (lib.versionAtLeast version "9.8" && lib.versionOlder version "9.11");
        in
        [
          # Fix docs build with Sphinx >= 7 https://gitlab.haskell.org/ghc/ghc/-/issues/24129
          (if lib.versionAtLeast version "9.8"
           then ./docs-sphinx-7-ghc98.patch
           else ./docs-sphinx-7.patch )
        ]
        ++ lib.optionals (lib.versionAtLeast version "9.6" && lib.versionOlder version "9.6.6") [
          (fetchpatch {
            name = "fix-fully_static.patch";
            url = "https://gitlab.haskell.org/ghc/ghc/-/commit/1bb24432ff77e11a0340a7d8586e151e15bba2a1.diff";
            hash = "sha256-MpvTmFFsNiPDoOp9BhZyWeapeibQ77zgEV+xzZ1UAXs=";
          })
        ]
        ++ lib.optionals (lib.versionAtLeast version "9.6" && lib.versionOlder version "9.8") [
          # Fix unlit being installed under a different name than is used in the
          # settings file: https://gitlab.haskell.org/ghc/ghc/-/issues/23317
          (fetchpatch {
            name = "ghc-9.6-fix-unlit-path.patch";
            url = "https://gitlab.haskell.org/ghc/ghc/-/commit/8fde4ac84ec7b1ead238cb158bbef48555d12af9.patch";
            hash = "sha256-3+CyRBpebEZi8YpS22SsdGQHqi0drR7cCKPtKbR3zyE=";
          })
        ]
        ++ lib.optionals (stdenv.targetPlatform.isDarwin && stdenv.targetPlatform.isAarch64) [
          # Prevent the paths module from emitting symbols that we don't use
          # when building with separate outputs.
          #
          # These cause problems as they're not eliminated by GHC's dead code
          # elimination on aarch64-darwin. (see
          # https://github.com/NixOS/nixpkgs/issues/140774 for details).
          (if lib.versionOlder version "9.10"
           then ./Cabal-at-least-3.6-paths-fix-cycle-aarch64-darwin.patch
           else ./Cabal-3.12-paths-fix-cycle-aarch64-darwin.patch)
        ]
        # Prevents passing --hyperlinked-source to haddock. Note that this can
        # be configured via a user defined flavour now. Unfortunately, it is
        # impossible to import an existing flavour in UserSettings, so patching
        # the defaults is actually simpler and less maintenance intensive
        # compared to keeping an entire flavour definition in sync with upstream
        # manually. See also https://gitlab.haskell.org/ghc/ghc/-/issues/23625
        ++ lib.optionals (!enableHyperlinkedSource) [
          (if lib.versionOlder version "9.8"
           then ../../tools/haskell/hadrian/disable-hyperlinked-source-pre-9.8.patch
           else ../../tools/haskell/hadrian/disable-hyperlinked-source-extra-args.patch)
        ]
        # Incorrect bounds on Cabal in hadrian
        # https://gitlab.haskell.org/ghc/ghc/-/issues/24100
        ++ lib.optionals (lib.elem version [ "9.8.1" "9.8.2" ]) [
          ../../tools/haskell/hadrian/hadrian-9.8.1-allow-Cabal-3.10.patch
        ];

      stdenv = stdenvNoCC;
    }

  # GHC's build system hadrian built from the GHC-to-build's source tree
  # using our bootstrap GHC.
, hadrian ? import ../../tools/haskell/hadrian/make-hadrian.nix { inherit bootPkgs lib; } {
    inherit ghcSrc;
    ghcVersion = version;
    userSettings = hadrianUserSettings;
  }

, #  Whether to build sphinx documentation.
  # TODO(@sternenseemann): Hadrian ignores the --docs flag if finalStage = Stage1
  enableDocs ? (
    # Docs disabled if we are building on musl because it's a large task to keep
    # all `sphinx` dependencies building in this environment.
    !stdenv.buildPlatform.isMusl
  )

, # Whether to disable the large address space allocator
  # necessary fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
  disableLargeAddressSpace ? stdenv.targetPlatform.isiOS

, # Whether to build an unregisterised version of GHC.
  # GHC will normally auto-detect whether it can do a registered build, but this
  # option will force it to do an unregistered build when set to true.
  # See https://gitlab.haskell.org/ghc/ghc/-/wikis/building/unregisterised
  enableUnregisterised ? false
}:

assert !enableNativeBignum -> gmp != null;

# GHC does not support building when all 3 platforms are different.
assert stdenv.buildPlatform == stdenv.hostPlatform || stdenv.hostPlatform == stdenv.targetPlatform;

# It is currently impossible to cross-compile GHC with Hadrian.
assert stdenv.buildPlatform == stdenv.hostPlatform;

let
  inherit (stdenv) buildPlatform hostPlatform targetPlatform;

  # TODO(@Ericson2314) Make unconditional
  targetPrefix = lib.optionalString
    (targetPlatform != hostPlatform)
    "${targetPlatform.config}-";

  hadrianSettings =
    # -fexternal-dynamic-refs apparently (because it's not clear from the
    # documentation) makes the GHC RTS able to load static libraries, which may
    # be needed for TemplateHaskell. This solution was described in
    # https://www.tweag.io/blog/2020-09-30-bazel-static-haskell
    lib.optionals enableRelocatedStaticLibs [
      "*.*.ghc.*.opts += -fPIC -fexternal-dynamic-refs"
    ]
    ++ lib.optionals targetPlatform.useAndroidPrebuilt [
      "*.*.ghc.c.opts += -optc-std=gnu99"
    ];

  # Splicer will pull out correct variations
  libDeps = platform: lib.optional enableTerminfo ncurses
    ++ lib.optionals (!targetPlatform.isGhcjs) [libffi]
    # Bindist configure script fails w/o elfutils in linker search path
    # https://gitlab.haskell.org/ghc/ghc/-/issues/22081
    ++ lib.optional enableDwarf elfutils
    ++ lib.optional (!enableNativeBignum) gmp
    ++ lib.optional (platform.libc != "glibc" && !targetPlatform.isWindows && !targetPlatform.isGhcjs) libiconv;

  # TODO(@sternenseemann): is buildTarget LLVM unnecessary?
  # GHC doesn't seem to have {LLC,OPT}_HOST
  toolsForTarget = [
    (if targetPlatform.isGhcjs
     then pkgsBuildTarget.emscripten
     else pkgsBuildTarget.targetPackages.stdenv.cc)
  ] ++ lib.optional useLLVM buildTargetLlvmPackages.llvm;

  buildCC = buildPackages.stdenv.cc;
  targetCC = builtins.head toolsForTarget;
  installCC =
    if targetPlatform.isGhcjs
    then pkgsHostTarget.emscripten
    else pkgsHostTarget.targetPackages.stdenv.cc;

  # toolPath calculates the absolute path to the name tool associated with a
  # given `stdenv.cc` derivation, i.e. it picks the correct derivation to take
  # the tool from (cc, cc.bintools, cc.bintools.bintools) and adds the correct
  # subpath of the tool.
  toolPath = name: cc:
    let
      tools = {
        "cc" = cc;
        "c++" = cc;
        as = cc.bintools;

        ar = cc.bintools;
        ranlib = cc.bintools;
        nm = cc.bintools;
        readelf = cc.bintools;
        objdump = cc.bintools;

        ld = cc.bintools;
        "ld.gold" = cc.bintools;

        otool = cc.bintools.bintools;

        # GHC needs install_name_tool on all darwin platforms. The same one can
        # be used on both platforms. It is safe to use with linker-generated
        # signatures because it will update the signatures automatically after
        # modifying the target binary.
        install_name_tool = cc.bintools.bintools;

        # strip on darwin is wrapped to enable deterministic mode.
        strip =
          # TODO(@sternenseemann): also use wrapper if linker == "bfd" or "gold"
          if stdenv.targetPlatform.isDarwin
          then cc.bintools
          else cc.bintools.bintools;

        # clang is used as an assembler on darwin with the LLVM backend
        clang = cc;
      }.${name};
    in
    "${tools}/bin/${tools.targetPrefix}${name}";

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

  # These libraries are library dependencies of the standard libraries bundled
  # by GHC (core libs) users will link their compiled artifacts again. Thus,
  # they should be taken from targetPackages.
  #
  # We need to use pkgsHostTarget if we are cross compiling a native GHC compiler,
  # though (when native compiling GHC, pkgsHostTarget == targetPackages):
  #
  # 1. targetPackages would be empty(-ish) in this situation since we can't
  #    execute cross compiled compilers in order to obtain the libraries
  #    that would be in targetPackages.
  # 2. pkgsHostTarget is fine to use since hostPlatform == targetPlatform in this
  #    situation.
  # 3. The core libs used by the final GHC (stage 2) for user artifacts are also
  #    used to build stage 2 GHC itself, i.e. the core libs are both host and
  #    target.
  targetLibs = {
    inherit
      (if hostPlatform != targetPlatform then targetPackages else pkgsHostTarget)
      elfutils
      gmp
      libffi
      ncurses;
  };

  # Our Cabal compiler name
  haskellCompilerName = "ghc-${version}";

in

stdenv.mkDerivation ({
  pname = "${targetPrefix}ghc${variantSuffix}";
  inherit version;

  src = ghcSrc;

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs --build .
  '';

  # GHC needs the locale configured during the Haddock phase.
  LANG = "en_US.UTF-8";

  # GHC is a bit confused on its cross terminology.
  # TODO(@sternenseemann): investigate coreutils dependencies and pass absolute paths
  preConfigure = ''
    for env in $(env | grep '^TARGET_' | sed -E 's|\+?=.*||'); do
      export "''${env#TARGET_}=''${!env}"
    done
    # No need for absolute paths since these tools only need to work during the build
    export CC_STAGE0="$CC_FOR_BUILD"
    export LD_STAGE0="$LD_FOR_BUILD"
    export AR_STAGE0="$AR_FOR_BUILD"

    # Stage0 (build->build) which builds stage 1
    export GHC="${bootPkgs.ghc}/bin/ghc"
    # GHC is a bit confused on its cross terminology, as these would normally be
    # the *host* tools.
    export CC="${toolPath "cc" targetCC}"
    export CXX="${toolPath "c++" targetCC}"
    # Use gold to work around https://sourceware.org/bugzilla/show_bug.cgi?id=16177
    export LD="${toolPath "ld${lib.optionalString useLdGold ".gold"}" targetCC}"
    export AS="${toolPath "as" targetCC}"
    export AR="${toolPath "ar" targetCC}"
    export NM="${toolPath "nm" targetCC}"
    export RANLIB="${toolPath "ranlib" targetCC}"
    export READELF="${toolPath "readelf" targetCC}"
    export STRIP="${toolPath "strip" targetCC}"
    export OBJDUMP="${toolPath "objdump" targetCC}"
  '' + lib.optionalString (stdenv.targetPlatform.linker == "cctools") ''
    export OTOOL="${toolPath "otool" targetCC}"
    export INSTALL_NAME_TOOL="${toolPath "install_name_tool" targetCC}"
  '' + lib.optionalString useLLVM ''
    export LLC="${lib.getBin buildTargetLlvmPackages.llvm}/bin/llc"
    export OPT="${lib.getBin buildTargetLlvmPackages.llvm}/bin/opt"
  '' + lib.optionalString (useLLVM && stdenv.targetPlatform.isDarwin) ''
    # LLVM backend on Darwin needs clang: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/codegens.html#llvm-code-generator-fllvm
    # The executable we specify via $CLANG is used as an assembler (exclusively, it seems, but this isn't
    # clarified in any user facing documentation). As such, it'll be called on assembly produced by $CC
    # which usually comes from the darwin stdenv. To prevent a situation where $CLANG doesn't understand
    # the assembly it is given, we need to make sure that it matches the LLVM version of $CC if possible.
    # It is unclear (at the time of writing 2024-09-01)  whether $CC should match the LLVM version we use
    # for llc and opt which would require using a custom darwin stdenv for targetCC.
    export CLANG="${
      if targetCC.isClang
      then toolPath "clang" targetCC
      else "${buildTargetLlvmPackages.clang}/bin/${buildTargetLlvmPackages.clang.targetPrefix}clang"
    }"
  '' +
  lib.optionalString (stdenv.hostPlatform.isLinux && hostPlatform.libc == "glibc") ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '' + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"

    # GHC tries the host xattr /usr/bin/xattr by default which fails since it expects python to be 2.7
    export XATTR=${lib.getBin xattr}/bin/xattr
  ''
  # If we are not using release tarballs, some files need to be generated using
  # the boot script.
  + lib.optionalString (rev != null) ''
    echo ${version} > VERSION
    echo ${rev} > GIT_COMMIT_ID
    ./boot
  ''
  + lib.optionalString targetPlatform.useAndroidPrebuilt ''
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
  # Need to make writable EM_CACHE for emscripten. The path in EM_CACHE must be absolute.
  # https://gitlab.haskell.org/ghc/ghc/-/wikis/javascript-backend#configure-fails-with-sub-word-sized-atomic-operations-not-available
  + lib.optionalString targetPlatform.isGhcjs ''
    export EM_CACHE="$(realpath $(mktemp -d emcache.XXXXXXXXXX))"
    cp -Lr ${targetCC /* == emscripten */}/share/emscripten/cache/* "$EM_CACHE/"
    chmod u+rwX -R "$EM_CACHE"
  ''
  # Create bash array hadrianFlagsArray for use in buildPhase. Do it in
  # preConfigure, so overrideAttrs can be used to modify it effectively.
  # hadrianSettings are passed via the command line so they are more visible
  # in the build log.
  + ''
    hadrianFlagsArray=(
      "-j$NIX_BUILD_CORES"
      ${lib.escapeShellArgs hadrianSettings}
    )
  '';

  ${if targetPlatform.isGhcjs then "configureScript" else null} = "emconfigure ./configure";
  # GHC currently ships an edited config.sub so ghcjs is accepted which we can not rollback
  ${if targetPlatform.isGhcjs then "dontUpdateAutotoolsGnuConfigScripts" else null} = true;

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ]
    ++ lib.optional (targetPlatform != hostPlatform) "target";

  # `--with` flags for libraries needed for RTS linker
  configureFlags = [
    "--datadir=$doc/share/doc/ghc"
  ] ++ lib.optionals enableTerminfo [
    "--with-curses-includes=${lib.getDev targetLibs.ncurses}/include"
    "--with-curses-libraries=${lib.getLib targetLibs.ncurses}/lib"
  ] ++ lib.optionals (libffi != null && !targetPlatform.isGhcjs) [
    "--with-system-libffi"
    "--with-ffi-includes=${targetLibs.libffi.dev}/include"
    "--with-ffi-libraries=${targetLibs.libffi.out}/lib"
  ] ++ lib.optionals (targetPlatform == hostPlatform && !enableNativeBignum) [
    "--with-gmp-includes=${targetLibs.gmp.dev}/include"
    "--with-gmp-libraries=${targetLibs.gmp.out}/lib"
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
  ] ++ lib.optionals enableDwarf [
    "--enable-dwarf-unwind"
    "--with-libdw-includes=${lib.getDev targetLibs.elfutils}/include"
    "--with-libdw-libraries=${lib.getLib targetLibs.elfutils}/lib"
  ] ++ lib.optionals targetPlatform.isDarwin [
    # Darwin uses llvm-ar. GHC will try to use `-L` with `ar` when it is `llvm-ar`
    # but it doesn’t currently work because Cabal never uses `-L` on Darwin. See:
    # https://gitlab.haskell.org/ghc/ghc/-/issues/23188
    # https://github.com/haskell/cabal/issues/8882
    "fp_cv_prog_ar_supports_dash_l=no"
  ] ++ lib.optionals enableUnregisterised [
    "--enable-unregisterised"
  ];

  # Make sure we never relax`$PATH` and hooks support for compatibility.
  strictDeps = true;

  # Don’t add -liconv to LDFLAGS automatically so that GHC will add it itself.
  dontAddExtraLibs = true;

  nativeBuildInputs = [
    perl hadrian bootPkgs.alex bootPkgs.happy bootPkgs.hscolour
    # autoconf and friends are necessary for hadrian to create the bindist
    autoconf automake m4
    # Python is used in a few scripts invoked by hadrian to generate e.g. rts headers.
    python3
    # Tool used to update GHC's settings file in postInstall
    bootPkgs.ghc-settings-edit
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
  ] ++ lib.optionals enableDocs [
    sphinx
  ];

  # For building runtime libs
  depsBuildTarget = toolsForTarget;
  # Everything the stage0 compiler needs to build stage1: CC, bintools, extra libs.
  # See also GHC, {CC,LD,AR}_STAGE0 in preConfigure.
  depsBuildBuild = [
    # N.B. We do not declare bootPkgs.ghc in any of the stdenv.mkDerivation
    # dependency lists to prevent the bintools setup hook from adding ghc's
    # lib directory to the linker flags. Instead we tell configure about it
    # via the GHC environment variable.
    buildCC
    # stage0 builds terminfo unconditionally, so we always need ncurses
    ncurses
  ];

  # Prevent stage0 ghc from leaking into the final result. This was an issue
  # with GHC 9.6.
  disallowedReferences = [
    bootPkgs.ghc
  ];

  buildInputs = [ bash ] ++ (libDeps hostPlatform);

  depsTargetTarget = map lib.getDev (libDeps targetPlatform);
  depsTargetTargetPropagated = map (lib.getOutput "out") (libDeps targetPlatform);

  hadrianFlags = [
    "--flavour=${ghcFlavour}"
    "--bignum=${if enableNativeBignum then "native" else "gmp"}"
    "--docs=${if enableDocs then "no-sphinx-pdfs" else "no-sphinx"}"
  ];

  buildPhase = ''
    runHook preBuild

    # hadrianFlagsArray is created in preConfigure
    echo "hadrianFlags: $hadrianFlags ''${hadrianFlagsArray[@]}"

    # We need to go via the bindist for installing
    hadrian $hadrianFlags "''${hadrianFlagsArray[@]}" binary-dist-dir

    runHook postBuild
  '';

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

  outputs = [ "out" "doc" ];

  # We need to configure the bindist *again* before installing
  # https://gitlab.haskell.org/ghc/ghc/-/issues/22058
  # TODO(@sternenseemann): it would be nice if the bindist could be an intermediate
  # derivation, but since it is > 2GB even on x86_64-linux, not a good idea?
  preInstall = ''
    pushd _build/bindist/*

  ''
  # the bindist configure script uses different env variables than the GHC configure script
  # see https://github.com/NixOS/nixpkgs/issues/267250 and https://gitlab.haskell.org/ghc/ghc/-/issues/24211
  + lib.optionalString (stdenv.targetPlatform.linker == "cctools") ''
    export InstallNameToolCmd=$INSTALL_NAME_TOOL
    export OtoolCmd=$OTOOL
  ''
  + ''
    $configureScript $configureFlags "''${configureFlagsArray[@]}"
  '';

  postInstall = ''
    # leave bindist directory
    popd

    settingsFile="$out/lib/${targetPrefix}${haskellCompilerName}/lib/settings"

    # Make the installed GHC use the host->target tools.
    ghc-settings-edit "$settingsFile" \
      "C compiler command" "${toolPath "cc" installCC}" \
      "Haskell CPP command" "${toolPath "cc" installCC}" \
      "C++ compiler command" "${toolPath "c++" installCC}" \
      "ld command" "${toolPath "ld${lib.optionalString useLdGold ".gold"}" installCC}" \
      "Merge objects command" "${toolPath "ld${lib.optionalString useLdGold ".gold"}" installCC}" \
      "ar command" "${toolPath "ar" installCC}" \
      "ranlib command" "${toolPath "ranlib" installCC}"
  ''
  + lib.optionalString (stdenv.targetPlatform.linker == "cctools") ''
    ghc-settings-edit "$settingsFile" \
      "otool command" "${toolPath "otool" installCC}" \
      "install_name_tool command" "${toolPath "install_name_tool" installCC}"
  ''
  + lib.optionalString useLLVM ''
    ghc-settings-edit "$settingsFile" \
      "LLVM llc command" "${lib.getBin llvmPackages.llvm}/bin/llc" \
      "LLVM opt command" "${lib.getBin llvmPackages.llvm}/bin/opt"
  ''
  + lib.optionalString (useLLVM && stdenv.targetPlatform.isDarwin) ''
    ghc-settings-edit "$settingsFile" \
      "LLVM clang command" "${
        # See comment for CLANG in preConfigure
        if installCC.isClang
        then toolPath "clang" installCC
        else "${llvmPackages.clang}/bin/${llvmPackages.clang.targetPrefix}clang"
      }"
  ''
  + ''

    # Install the bash completion file.
    install -Dm 644 utils/completion/ghc.bash $out/share/bash-completion/completions/${targetPrefix}ghc
  '';

  passthru = {
    inherit bootPkgs targetPrefix haskellCompilerName;

    inherit llvmPackages;
    inherit enableShared;

    # Expose hadrian used for bootstrapping, for debugging purposes
    inherit hadrian;

    # TODO(@sternenseemann): there's no stage0:exe:haddock target by default,
    # so haddock isn't available for GHC cross-compilers. Can we fix that?
    hasHaddock = stdenv.hostPlatform == stdenv.targetPlatform;
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "Glasgow Haskell Compiler";
    maintainers = with lib.maintainers; [
      guibou
    ] ++ lib.teams.haskell.members;
    timeout = 24 * 3600;
    platforms = lib.platforms.all;
    inherit (bootPkgs.ghc.meta) license;
  };

  dontStrip = targetPlatform.useAndroidPrebuilt || targetPlatform.isWasm;
} // lib.optionalAttrs targetPlatform.useAndroidPrebuilt {
  dontPatchELF = true;
  noAuditTmpdir = true;
})
