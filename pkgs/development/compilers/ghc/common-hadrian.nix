{ version
, rev ? null
, sha256
, url ?
    if rev != null
    then "https://gitlab.haskell.org/ghc/ghc.git"
    else "https://downloads.haskell.org/ghc/${version}/ghc-${version}-src.tar.xz"

}:

{ lib
, stdenv
, pkgsBuildTarget
, pkgsHostTarget
, targetPackages

# build-tools
, bootPkgs
, autoconf
, automake
, coreutils
, fetchpatch
, fetchurl
, fetchgit
, perl
, python3
, m4
, sphinx
, xattr
, autoSignDarwinBinariesHook
, bash

, libiconv ? null, ncurses
, glibcLocales ? null

, # GHC can be built with system libffi or a bundled one.
  libffi ? null

, useLLVM ? !(stdenv.targetPlatform.isx86
              || stdenv.targetPlatform.isPower
              || stdenv.targetPlatform.isSparc
              || (stdenv.targetPlatform.isAarch64 && stdenv.targetPlatform.isDarwin)
              || stdenv.targetPlatform.isGhcjs)
, # LLVM is conceptually a run-time-only depedendency, but for
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

  # aarch64 outputs otherwise exceed 2GB limit
, enableProfiledLibs ? !stdenv.targetPlatform.isAarch64

, # Whether to build dynamic libs for the standard library (on the target
  # platform). Static libs are always built.
  enableShared ? with stdenv.targetPlatform; !isWindows && !useiOSPrebuilt && !isStatic && !isGhcjs

, # Whether to build terminfo.
  enableTerminfo ? !(stdenv.targetPlatform.isWindows
                     || stdenv.targetPlatform.isGhcjs)

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
      if stdenv.hostPlatform == stdenv.targetPlatform
      then "Stage2" # native compiler
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

, #  Whether to build sphinx documentation.
  enableDocs ? (
    # Docs disabled for musl and cross because it's a large task to keep
    # all `sphinx` dependencies building in those environments.
    # `sphinx` pulls in among others:
    # Ruby, Python, Perl, Rust, OpenGL, Xorg, gtk, LLVM.
    (stdenv.targetPlatform == stdenv.hostPlatform)
    && !stdenv.hostPlatform.isMusl
  )

, # Whether to disable the large address space allocator
  # necessary fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
  disableLargeAddressSpace ? stdenv.targetPlatform.isiOS
}:

assert !enableNativeBignum -> gmp != null;

let
  src = (if rev != null then fetchgit else fetchurl) ({
    inherit url sha256;
  } // lib.optionalAttrs (rev != null) {
    inherit rev;
  });

  inherit (stdenv) buildPlatform hostPlatform targetPlatform;

  inherit (bootPkgs) ghc;

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

  # GHC's build system hadrian built from the GHC-to-build's source tree
  # using our bootstrap GHC.
  hadrian = bootPkgs.callPackage ../../tools/haskell/hadrian {
    ghcSrc = src;
    ghcVersion = version;
    userSettings = hadrianUserSettings;
  };

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
assert !targetPlatform.isGhcjs -> targetCC == pkgsHostTarget.targetPackages.stdenv.cc;
assert buildTargetLlvmPackages.llvm == llvmPackages.llvm;
assert stdenv.targetPlatform.isDarwin -> buildTargetLlvmPackages.clang == llvmPackages.clang;

stdenv.mkDerivation ({
  pname = "${targetPrefix}ghc${variantSuffix}";
  inherit version;

  inherit src;

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
  '' +
  lib.optionalString (stdenv.isLinux && hostPlatform.libc == "glibc") ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '' + lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
  '' + lib.optionalString stdenv.isDarwin ''
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
  # Need to make writable EM_CACHE for emscripten
  # https://gitlab.haskell.org/ghc/ghc/-/wikis/javascript-backend#configure-fails-with-sub-word-sized-atomic-operations-not-available
  + lib.optionalString targetPlatform.isGhcjs ''
    export EM_CACHE="$(mktemp -d emcache.XXXXXXXXXX)"
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
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
  ] ++ lib.optionals (libffi != null && !targetPlatform.isGhcjs) [
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
  ] ++ lib.optionals enableDwarf [
    "--enable-dwarf-unwind"
    "--with-libdw-includes=${lib.getDev elfutils}/include"
    "--with-libdw-libraries=${lib.getLib elfutils}/lib"
  ];

  # Make sure we never relax`$PATH` and hooks support for compatibility.
  strictDeps = true;

  # Don’t add -liconv to LDFLAGS automatically so that GHC will add it itself.
  dontAddExtraLibs = true;

  nativeBuildInputs = [
    perl ghc hadrian bootPkgs.alex bootPkgs.happy bootPkgs.hscolour
    # autoconf and friends are necessary for hadrian to create the bindist
    autoconf automake m4
    # Python is used in a few scripts invoked by hadrian to generate e.g. rts headers.
    python3
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    autoSignDarwinBinariesHook
  ] ++ lib.optionals enableDocs [
    sphinx
  ];

  # For building runtime libs
  depsBuildTarget = toolsForTarget;

  buildInputs = [ perl bash ] ++ (libDeps hostPlatform);

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

    $configureScript $configureFlags "''${configureFlagsArray[@]}"
  '';

  postInstall = ''
    # leave bindist directory
    popd

    # Install the bash completion file.
    install -Dm 644 utils/completion/ghc.bash $out/share/bash-completion/completions/${targetPrefix}ghc
  '';

  passthru = {
    inherit bootPkgs targetPrefix;

    inherit llvmPackages;
    inherit enableShared;

    # Our Cabal compiler name
    haskellCompilerName = "ghc-${version}";

    # Expose hadrian used for bootstrapping, for debugging purposes
    inherit hadrian;
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with lib.maintainers; [
      guibou
    ] ++ lib.teams.haskell.members;
    timeout = 24 * 3600;
    inherit (ghc.meta) license platforms;
  };

  dontStrip = targetPlatform.useAndroidPrebuilt || targetPlatform.isWasm;
} // lib.optionalAttrs targetPlatform.useAndroidPrebuilt {
  dontPatchELF = true;
  noAuditTmpdir = true;
})
