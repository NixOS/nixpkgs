{
  version,
  sha256,
  url ? "https://downloads.haskell.org/ghc/${version}/ghc-${version}-src.tar.xz",
}:

{
  lib,
  stdenv,
  pkgsBuildTarget,
  pkgsHostTarget,
  buildPackages,
  targetPackages,

  # build-tools
  bootPkgs,
  autoconf,
  automake,
  coreutils,
  fetchpatch,
  fetchurl,
  perl,
  python3,
  m4,
  sphinx,
  xattr,
  autoSignDarwinBinariesHook,
  bash,

  libiconv ? null,
  ncurses,
  glibcLocales ? null,

  # GHC can be built with system libffi or a bundled one.
  libffi ? null,

  useLLVM ? !(import ./common-have-ncg.nix { inherit lib stdenv version; }),

  # LLVM is conceptually a run-time-only dependency, but for
  # non-x86, we need LLVM to bootstrap later stages, so it becomes a
  # build-time dependency too.
  buildTargetLlvmPackages,
  llvmPackages,

  # If enabled, GHC will be built with the GPL-free but slightly slower native
  # bignum backend instead of the faster but GPLed gmp backend.
  enableNativeBignum ?
    !(lib.meta.availableOn stdenv.hostPlatform gmp && lib.meta.availableOn stdenv.targetPlatform gmp),
  gmp,

  # If enabled, use -fPIC when compiling static libs.
  enableRelocatedStaticLibs ? stdenv.targetPlatform != stdenv.hostPlatform,

  # Exceeds Hydra output limit (at the time of writing ~3GB) when cross compiled to riscv64.
  # A riscv64 cross-compiler fits into the limit comfortably.
  enableProfiledLibs ? !stdenv.hostPlatform.isRiscV64,

  # Whether to build dynamic libs for the standard library (on the target
  # platform). Static libs are always built.
  enableShared ? with stdenv.targetPlatform; !isWindows && !useiOSPrebuilt && !isStatic,

  # Whether to build terminfo.
  enableTerminfo ?
    !(
      stdenv.targetPlatform.isWindows
      # terminfo can't be built for cross
      || (stdenv.buildPlatform != stdenv.hostPlatform)
      || (stdenv.hostPlatform != stdenv.targetPlatform)
    ),

  # Enable NUMA support in RTS
  enableNuma ? lib.meta.availableOn stdenv.targetPlatform numactl,
  numactl,

  # What flavour to build. An empty string indicates no
  # specific flavour and falls back to ghc default values.
  ghcFlavour ? lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform) (
    if useLLVM then "perf-cross" else "perf-cross-ncg"
  ),

  #  Whether to build sphinx documentation.
  enableDocs ? (
    # Docs disabled if we are building on musl because it's a large task to keep
    # all `sphinx` dependencies building in this environment.
    !stdenv.buildPlatform.isMusl
  ),

  enableHaddockProgram ?
    # Disabled for cross; see note [HADDOCK_DOCS].
    (stdenv.buildPlatform == stdenv.hostPlatform && stdenv.targetPlatform == stdenv.hostPlatform),

  # Whether to disable the large address space allocator
  # necessary fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
  disableLargeAddressSpace ? stdenv.targetPlatform.isiOS,

  # Whether to build an unregisterised version of GHC.
  # GHC will normally auto-detect whether it can do a registered build, but this
  # option will force it to do an unregistered build when set to true.
  # See https://gitlab.haskell.org/ghc/ghc/-/wikis/building/unregisterised
  # Registerised RV64 compiler produces programs that segfault
  # See https://gitlab.haskell.org/ghc/ghc/-/issues/23957
  enableUnregisterised ? stdenv.hostPlatform.isRiscV64 || stdenv.targetPlatform.isRiscV64,
}:

assert !enableNativeBignum -> gmp != null;

# Cross cannot currently build the `haddock` program for silly reasons,
# see note [HADDOCK_DOCS].
assert
  (stdenv.buildPlatform != stdenv.hostPlatform || stdenv.targetPlatform != stdenv.hostPlatform)
  -> !enableHaddockProgram;

# GHC does not support building when all 3 platforms are different.
assert stdenv.buildPlatform == stdenv.hostPlatform || stdenv.hostPlatform == stdenv.targetPlatform;

let
  inherit (stdenv) buildPlatform hostPlatform targetPlatform;

  # TODO(@Ericson2314) Make unconditional
  targetPrefix = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";

  buildMK = ''
    BuildFlavour = ${ghcFlavour}
    ifneq \"\$(BuildFlavour)\" \"\"
    include mk/flavours/\$(BuildFlavour).mk
    endif
    BUILD_SPHINX_HTML = ${if enableDocs then "YES" else "NO"}
    BUILD_SPHINX_PDF = NO

    WITH_TERMINFO = ${if enableTerminfo then "YES" else "NO"}
  ''
  +
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
    ''
  + lib.optionalString (targetPlatform != hostPlatform) ''
    Stage1Only = ${if targetPlatform.system == hostPlatform.system then "NO" else "YES"}
    CrossCompilePrefix = ${targetPrefix}
  ''
  + lib.optionalString (!enableProfiledLibs) ''
    BUILD_PROF_LIBS = NO
  ''
  +
    # -fexternal-dynamic-refs apparently (because it's not clear from the documentation)
    # makes the GHC RTS able to load static libraries, which may be needed for TemplateHaskell.
    # This solution was described in https://www.tweag.io/blog/2020-09-30-bazel-static-haskell
    lib.optionalString enableRelocatedStaticLibs ''
      GhcLibHcOpts += -fPIC -fexternal-dynamic-refs
      GhcRtsHcOpts += -fPIC -fexternal-dynamic-refs
    ''
  + lib.optionalString targetPlatform.useAndroidPrebuilt ''
    EXTRA_CC_OPTS += -std=gnu99
  '';

  # Splicer will pull out correct variations
  libDeps =
    platform:
    lib.optional enableTerminfo ncurses
    ++ [ libffi ]
    ++ lib.optional (!enableNativeBignum) gmp
    ++ lib.optional (platform.libc != "glibc" && !targetPlatform.isWindows) libiconv;

  # TODO(@sternenseemann): is buildTarget LLVM unnecessary?
  # GHC doesn't seem to have {LLC,OPT}_HOST
  toolsForTarget = [
    pkgsBuildTarget.targetPackages.stdenv.cc
  ]
  ++ lib.optional useLLVM buildTargetLlvmPackages.llvm;

  buildCC = buildPackages.stdenv.cc;
  targetCC = builtins.head toolsForTarget;
  installCC = pkgsHostTarget.targetPackages.stdenv.cc;

  # toolPath calculates the absolute path to the name tool associated with a
  # given `stdenv.cc` derivation, i.e. it picks the correct derivation to take
  # the tool from (cc, cc.bintools, cc.bintools.bintools) and adds the correct
  # subpath of the tool.
  toolPath =
    name: cc:
    let
      tools =
        {
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
            if stdenv.targetPlatform.isDarwin then cc.bintools else cc.bintools.bintools;

          # clang is used as an assembler on darwin with the LLVM backend
          clang = cc;
        }
        .${name};
    in
    "${tools}/bin/${tools.targetPrefix}${name}";

  # Use gold either following the default, or to avoid the BFD linker due to some bugs / perf issues.
  # But we cannot avoid BFD when using musl libc due to https://sourceware.org/bugzilla/show_bug.cgi?id=23856
  # see #84670 and #49071 for more background.
  useLdGold =
    targetPlatform.linker == "gold"
    || (
      targetPlatform.linker == "bfd"
      && (targetCC.bintools.bintools.hasGold or false)
      && !targetPlatform.isMusl
    );

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
    inherit (if hostPlatform != targetPlatform then targetPackages else pkgsHostTarget)
      gmp
      libffi
      ncurses
      numactl
      ;
  };

in

stdenv.mkDerivation (
  rec {
    pname = "${targetPrefix}ghc${variantSuffix}";
    inherit version;

    src = fetchurl {
      inherit url sha256;
    };

    enableParallelBuilding = true;

    outputs = [
      "out"
      "doc"
    ];

    patches = [
      # Determine size of time related types using hsc2hs instead of assuming CLong.
      # Prevents failures when e.g. stat(2)ing on 32bit systems with 64bit time_t etc.
      # https://github.com/haskell/ghcup-hs/issues/1107
      # https://gitlab.haskell.org/ghc/ghc/-/issues/25095
      # Note that in normal situations this shouldn't be the case since nixpkgs
      # doesn't set -D_FILE_OFFSET_BITS=64 and friends (yet).
      (fetchpatch {
        name = "unix-fix-ctimeval-size-32-bit.patch";
        url = "https://github.com/haskell/unix/commit/8183e05b97ce870dd6582a3677cc82459ae566ec.patch";
        sha256 = "17q5yyigqr5kxlwwzb95sx567ysfxlw6bp3j4ji20lz0947aw6gv";
        stripLen = 1;
        extraPrefix = "libraries/unix/";
      })

      # Fix docs build with Sphinx >= 7 https://gitlab.haskell.org/ghc/ghc/-/issues/24129
      ./docs-sphinx-7.patch

      # Correctly record libnuma's library and include directories in the
      # package db. This fixes linking whenever stdenv and propagation won't
      # quite pass the correct -L flags to the linker, e.g. when using GHC
      # outside of stdenv/nixpkgs or build->build compilation in pkgsStatic.
      ./ghc-9.4-rts-package-db-libnuma-dirs.patch
    ]

    # Before GHC 9.6, GHC, when used to compile C sources (i.e. to drive the CC), would first
    # invoke the C compiler to generate assembly and later call the assembler on the result of
    # that operation. Unfortunately, that is brittle in a lot of cases, e.g. when using mismatched
    # CC / assembler (https://gitlab.haskell.org/ghc/ghc/-/merge_requests/12005). This issue
    # does not affect us. However, LLVM 18 introduced a check in clang that makes sure no
    # non private labels occur between .cfi_startproc and .cfi_endproc which causes the
    # assembly that the same version (!) of clang generates from rts/StgCRun.c to be rejected.
    # This causes GHC to fail compilation on mach-o platforms ever since we upgraded to
    # LLVM 19.
    #
    # clang compiles the same file without issues whithout the roundtrip via assembly. Thus,
    # the solution is to backport those changes from GHC 9.6 that skip the intermediate
    # assembly step.
    #
    # https://gitlab.haskell.org/ghc/ghc/-/issues/25608#note_622589
    # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/6877
    ++ [
      # Need to use this patch so the next one applies, passes file location info to the cc phase
      (fetchpatch {
        name = "ghc-add-location-to-cc-phase.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/4a7256a75af2fc0318bef771a06949ffb3939d5a.patch";
        hash = "sha256-DnTI+i1zMebeWvw75D59vMaEEBb2Nr9HusxTyhmdy2M=";
      })
      # Makes Cc phase directly generate object files instead of assembly
      (fetchpatch {
        name = "ghc-cc-directly-emit-object.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/96811ba491495b601ec7d6a32bef8563b0292109.patch";
        hash = "sha256-G8u7/MK/tGOEN8Wxccxj/YIOP7mL2G9Co1WKdHXOo6I=";
      })
    ]

    ++ [
      # Don't generate code that doesn't compile when --enable-relocatable is passed to Setup.hs
      # Can be removed if the Cabal library included with ghc backports the linked fix
      (fetchpatch {
        url = "https://github.com/haskell/cabal/commit/6c796218c92f93c95e94d5ec2d077f6956f68e98.patch";
        stripLen = 1;
        extraPrefix = "libraries/Cabal/";
        sha256 = "sha256-yRQ6YmMiwBwiYseC5BsrEtDgFbWvst+maGgDtdD0vAY=";
      })
    ]

    # Fixes stack overrun in rts which crashes an process whenever
    # freeHaskellFunPtr is called with nixpkgs' hardening flags.
    # https://gitlab.haskell.org/ghc/ghc/-/issues/25485
    # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/13599
    # TODO: patch doesn't apply for < 9.4, but may still be necessary?
    ++ [
      (fetchpatch {
        name = "ghc-rts-adjustor-fix-i386-stack-overrun.patch";
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/39bb6e583d64738db51441a556d499aa93a4fc4a.patch";
        sha256 = "0w5fx413z924bi2irsy1l4xapxxhrq158b5gn6jzrbsmhvmpirs0";
      })
    ]

    ++ lib.optionals (stdenv.targetPlatform.isDarwin && stdenv.targetPlatform.isAarch64) [
      # Prevent the paths module from emitting symbols that we don't use
      # when building with separate outputs.
      #
      # These cause problems as they're not eliminated by GHC's dead code
      # elimination on aarch64-darwin. (see
      # https://github.com/NixOS/nixpkgs/issues/140774 for details).
      ./Cabal-at-least-3.6-paths-fix-cycle-aarch64-darwin.patch
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
    ''
    + lib.optionalString (stdenv.targetPlatform.linker == "cctools") ''
      export OTOOL="${toolPath "otool" targetCC}"
      export INSTALL_NAME_TOOL="${toolPath "install_name_tool" targetCC}"
    ''
    + lib.optionalString useLLVM ''
      export LLC="${lib.getBin buildTargetLlvmPackages.llvm}/bin/llc"
      export OPT="${lib.getBin buildTargetLlvmPackages.llvm}/bin/opt"
    ''
    + lib.optionalString (useLLVM && stdenv.targetPlatform.isDarwin) ''
      # LLVM backend on Darwin needs clang: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/codegens.html#llvm-code-generator-fllvm
      # The executable we specify via $CLANG is used as an assembler (exclusively, it seems, but this isn't
      # clarified in any user facing documentation). As such, it'll be called on assembly produced by $CC
      # which usually comes from the darwin stdenv. To prevent a situation where $CLANG doesn't understand
      # the assembly it is given, we need to make sure that it matches the LLVM version of $CC if possible.
      # It is unclear (at the time of writing 2024-09-01)  whether $CC should match the LLVM version we use
      # for llc and opt which would require using a custom darwin stdenv for targetCC.
      export CLANG="${
        if targetCC.isClang then
          toolPath "clang" targetCC
        else
          "${buildTargetLlvmPackages.clang}/bin/${buildTargetLlvmPackages.clang.targetPrefix}clang"
      }"
    ''
    + ''
      # No need for absolute paths since these tools only need to work during the build
      export CC_STAGE0="$CC_FOR_BUILD"
      export LD_STAGE0="$LD_FOR_BUILD"
      export AR_STAGE0="$AR_FOR_BUILD"

      echo -n "${buildMK}" > mk/build.mk
      sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux && hostPlatform.libc == "glibc") ''
      export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin) ''

      # GHC tries the host xattr /usr/bin/xattr by default which fails since it expects python to be 2.7
      export XATTR=${lib.getBin xattr}/bin/xattr
    ''
    + lib.optionalString targetPlatform.useAndroidPrebuilt ''
      sed -i -e '5i ,("armv7a-unknown-linux-androideabi", ("e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64", "cortex-a8", ""))' llvm-targets
    ''
    + lib.optionalString targetPlatform.isMusl ''
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
    '';

    # Although it is usually correct to pass --host, we don't do that here because
    # GHC's usage of build, host, and target is non-standard.
    # See https://gitlab.haskell.org/ghc/ghc/-/wikis/building/cross-compiling
    # TODO(@Ericson2314): Always pass "--target" and always prefix.
    configurePlatforms = [
      "build"
    ]
    ++ lib.optional (buildPlatform != hostPlatform || targetPlatform != hostPlatform) "target";

    # `--with` flags for libraries needed for RTS linker
    configureFlags = [
      "--datadir=$doc/share/doc/ghc"
    ]
    ++ lib.optionals enableTerminfo [
      "--with-curses-includes=${lib.getDev targetLibs.ncurses}/include"
      "--with-curses-libraries=${lib.getLib targetLibs.ncurses}/lib"
    ]
    ++ lib.optionals (libffi != null) [
      "--with-system-libffi"
      "--with-ffi-includes=${targetLibs.libffi.dev}/include"
      "--with-ffi-libraries=${targetLibs.libffi.out}/lib"
    ]
    ++ lib.optionals (targetPlatform == hostPlatform && !enableNativeBignum) [
      "--with-gmp-includes=${targetLibs.gmp.dev}/include"
      "--with-gmp-libraries=${targetLibs.gmp.out}/lib"
    ]
    ++
      lib.optionals
        (targetPlatform == hostPlatform && hostPlatform.libc != "glibc" && !targetPlatform.isWindows)
        [
          "--with-iconv-includes=${libiconv}/include"
          "--with-iconv-libraries=${libiconv}/lib"
        ]
    ++ lib.optionals (targetPlatform != hostPlatform) [
      "--enable-bootstrap-with-devel-snapshot"
    ]
    ++ lib.optionals useLdGold [
      "CFLAGS=-fuse-ld=gold"
      "CONF_GCC_LINKER_OPTS_STAGE1=-fuse-ld=gold"
      "CONF_GCC_LINKER_OPTS_STAGE2=-fuse-ld=gold"
    ]
    ++ lib.optionals (disableLargeAddressSpace) [
      "--disable-large-address-space"
    ]
    ++ lib.optionals enableNuma [
      "--enable-numa"
      "--with-libnuma-includes=${lib.getDev targetLibs.numactl}/include"
      "--with-libnuma-libraries=${lib.getLib targetLibs.numactl}/lib"
    ]
    ++ lib.optionals enableUnregisterised [
      "--enable-unregisterised"
    ];

    # Make sure we never relax`$PATH` and hooks support for compatibility.
    strictDeps = true;

    # Don’t add -liconv to LDFLAGS automatically so that GHC will add it itself.
    dontAddExtraLibs = true;

    nativeBuildInputs = [
      perl
      autoconf
      automake
      m4
      python3
      bootPkgs.alex
      bootPkgs.happy
      bootPkgs.hscolour
      bootPkgs.ghc-settings-edit
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ]
    ++ lib.optionals enableDocs [
      sphinx
    ];

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
    # For building runtime libs
    depsBuildTarget = toolsForTarget;

    # Prevent stage0 ghc from leaking into the final result. This was an issue
    # with GHC 9.6.
    disallowedReferences = [
      bootPkgs.ghc
    ];

    buildInputs = [ bash ] ++ (libDeps hostPlatform);

    # stage1 GHC doesn't need to link against libnuma, so it's target specific
    depsTargetTarget = map lib.getDev (
      libDeps targetPlatform ++ lib.optionals enableNuma [ targetLibs.numactl ]
    );
    depsTargetTargetPropagated = map (lib.getOutput "out") (
      libDeps targetPlatform ++ lib.optionals enableNuma [ targetLibs.numactl ]
    );

    # required, because otherwise all symbols from HSffi.o are stripped, and
    # that in turn causes GHCi to abort
    stripDebugFlags = [ "-S" ] ++ lib.optional (!targetPlatform.isDarwin) "--keep-file-symbols";

    checkTarget = "test";

    # GHC cannot currently produce outputs that are ready for `-pie` linking.
    # Thus, disable `pie` hardening, otherwise `recompile with -fPIE` errors appear.
    # See:
    # * https://github.com/NixOS/nixpkgs/issues/129247
    # * https://gitlab.haskell.org/ghc/ghc/-/issues/19580
    hardeningDisable = [
      "format"
      "pie"
    ];

    # big-parallel allows us to build with more than 2 cores on
    # Hydra which already warrants a significant speedup
    requiredSystemFeatures = [ "big-parallel" ];

    # Install occasionally fails due to a race condition in minimal builds.
    # > /nix/store/wyzpysxwgs3qpvmylm9krmfzh2plicix-coreutils-9.7/bin/install -c -m 755 -d "/nix/store/xzb3390rhvhg2a0cvzmrvjspw1d8nf8h-ghc-riscv64-unknown-linux-gnu-9.4.8/bin"
    # > install: cannot create regular file '/nix/store/xzb3390rhvhg2a0cvzmrvjspw1d8nf8h-ghc-riscv64-unknown-linux-gnu-9.4.8/lib/ghc-9.4.8': No such file or directory
    preInstall = ''
      mkdir -p "$out/lib/${passthru.haskellCompilerName}"
    '';

    postInstall = ''
      settingsFile="$out/lib/${targetPrefix}${passthru.haskellCompilerName}/settings"

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
          if installCC.isClang then
            toolPath "clang" installCC
          else
            "${llvmPackages.clang}/bin/${llvmPackages.clang.targetPrefix}clang"
        }"
    ''
    + ''

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

      bootstrapAvailable = lib.meta.availableOn stdenv.buildPlatform bootPkgs.ghc;
    };

    meta = {
      homepage = "http://haskell.org/ghc";
      description = "Glasgow Haskell Compiler";
      maintainers = with lib.maintainers; [
        guibou
      ];
      teams = [ lib.teams.haskell ];
      timeout = 24 * 3600;
      platforms = lib.platforms.all;
      inherit (bootPkgs.ghc.meta) license;
    };

  }
  // lib.optionalAttrs targetPlatform.useAndroidPrebuilt {
    dontStrip = true;
    dontPatchELF = true;
    noAuditTmpdir = true;
  }
)
