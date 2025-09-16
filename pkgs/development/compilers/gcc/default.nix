{
  lib,
  stdenv,
  targetPackages,
  fetchurl,
  fetchpatch,
  noSysDirs,
  langC ? true,
  langCC ? true,
  langFortran ? false,
  langAda ? false,
  langObjC ? stdenv.targetPlatform.isDarwin,
  langObjCpp ? stdenv.targetPlatform.isDarwin,
  langGo ? false,
  reproducibleBuild ? true,
  profiledCompiler ? false,
  langJit ? false,
  langRust ? false,
  cargo,
  staticCompiler ? false,
  enableShared ? stdenv.targetPlatform.hasSharedLibraries,
  enableLTO ? stdenv.hostPlatform.hasSharedLibraries,
  texinfo ? null,
  perl ? null, # optional, for texi2pod (then pod2man)
  gmp,
  mpfr,
  libmpc,
  gettext,
  which,
  patchelf,
  binutils,
  isl ? null, # optional, for the Graphite optimization framework.
  zlib ? null,
  libucontext ? null,
  gnat-bootstrap ? null,
  enableMultilib ? false,
  enablePlugin ? (lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform), # Whether to support user-supplied plug-ins
  name ? "gcc",
  libcCross ? null,
  threadsCross ? { }, # for MinGW
  withoutTargetLibc ? stdenv.targetPlatform.libc == null,
  flex,
  gnused ? null,
  buildPackages,
  pkgsBuildTarget,
  libxcrypt,
  disableGdbPlugin ?
    !enablePlugin
    || (stdenv.targetPlatform.isAvr && stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64),
  nukeReferences,
  callPackage,
  majorMinorVersion,
  apple-sdk,
  darwin,
}:

let
  inherit (lib)
    callPackageWith
    filter
    getBin
    maintainers
    makeLibraryPath
    makeSearchPathOutput
    mapAttrs
    optional
    optionalAttrs
    optionals
    optionalString
    pipe
    platforms
    versionAtLeast
    versions
    ;

  gccVersions = import ./versions.nix;
  version = gccVersions.fromMajorMinor majorMinorVersion;

  majorVersion = versions.major version;
  atLeast14 = versionAtLeast version "14";
  is14 = majorVersion == "14";
  is13 = majorVersion == "13";

  # releases have a form: MAJOR.MINOR.MICRO, like 14.2.1
  # snapshots have a form like MAJOR.MINOR.MICRO.DATE, like 14.2.1.20250322
  isSnapshot = lib.length (lib.splitVersion version) == 4;
  # return snapshot date of gcc's given version:
  #   "14.2.1.20250322" -> "20250322"
  #   "14.2.0" -> ""
  snapDate = lib.concatStrings (lib.drop 3 (lib.splitVersion version));
  # return base version without a snapshot:
  #   "14.2.1.20250322" -> "14.2.1"
  #   "14.2.0" -> "14.2.0"
  baseVersion = lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version));

  disableBootstrap = !stdenv.hostPlatform.isDarwin && !profiledCompiler;

  inherit (stdenv) buildPlatform hostPlatform targetPlatform;
  targetConfig =
    if (!lib.systems.equals targetPlatform hostPlatform) then targetPlatform.config else null;

  patches = callFile ./patches { };

  # Cross-gcc settings (build == host != target)
  crossMingw = (!lib.systems.equals targetPlatform hostPlatform) && targetPlatform.isMinGW;
  stageNameAddon = optionalString withoutTargetLibc "-nolibc";
  crossNameAddon = optionalString (
    !lib.systems.equals targetPlatform hostPlatform
  ) "${targetPlatform.config}${stageNameAddon}-";

  targetPrefix = lib.optionalString (
    !lib.systems.equals stdenv.targetPlatform stdenv.hostPlatform
  ) "${stdenv.targetPlatform.config}-";

  callFile = callPackageWith {
    # lets
    inherit
      majorVersion
      isSnapshot
      version
      buildPlatform
      hostPlatform
      targetPlatform
      targetConfig
      patches
      crossMingw
      stageNameAddon
      crossNameAddon
      ;
    # inherit generated with 'nix eval --json --impure --expr "with import ./. {}; lib.attrNames (lib.functionArgs gcc${majorVersion}.cc.override)" | jq '.[]' --raw-output'
    inherit
      apple-sdk
      binutils
      buildPackages
      cargo
      withoutTargetLibc
      darwin
      disableBootstrap
      disableGdbPlugin
      enableLTO
      enableMultilib
      enablePlugin
      enableShared
      fetchpatch
      fetchurl
      flex
      gettext
      gmp
      gnat-bootstrap
      gnused
      isl
      langAda
      langC
      langCC
      langFortran
      langGo
      langJit
      langObjC
      langObjCpp
      langRust
      lib
      libcCross
      libmpc
      libucontext
      libxcrypt
      mpfr
      name
      noSysDirs
      nukeReferences
      patchelf
      perl
      pkgsBuildTarget
      profiledCompiler
      reproducibleBuild
      staticCompiler
      stdenv
      targetPackages
      texinfo
      threadsCross
      which
      zlib
      ;
  };

in

# Make sure we get GNU sed.
assert stdenv.buildPlatform.isDarwin -> gnused != null;

# The go frontend is written in c++
assert langGo -> langCC;
assert langAda -> gnat-bootstrap != null;

# threadsCross is just for MinGW
assert threadsCross != { } -> stdenv.targetPlatform.isWindows;

# profiledCompiler builds inject non-determinism in one of the compilation stages.
# If turned on, we can't provide reproducible builds anymore
assert reproducibleBuild -> profiledCompiler == false;

pipe
  ((callFile ./common/builder.nix { }) (
    {
      pname = "${crossNameAddon}${name}";
      # retain snapshot date in package version, but not in final version
      # as the version is frequently used to construct pathnames (at least
      # in cc-wrapper).
      name = "${crossNameAddon}${name}-${version}";
      version = baseVersion;

      src = fetchurl {
        url =
          if isSnapshot then
            "mirror://gcc/snapshots/${majorVersion}-${snapDate}/gcc-${majorVersion}-${snapDate}.tar.xz"
          else
            "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
        ${if is13 then "hash" else "sha256"} = gccVersions.srcHashForVersion version;
      };

      inherit patches;

      outputs = [
        "out"
        "man"
        "info"
      ]
      ++ optional (!langJit) "lib";

      setOutputFlags = false;

      libc_dev = stdenv.cc.libc_dev;

      hardeningDisable = [
        "format"
        "pie"
        "stackclashprotection"
      ];

      postPatch = ''
        configureScripts=$(find . -name configure)
        for configureScript in $configureScripts; do
          patchShebangs $configureScript
        done

        # Make sure nixpkgs versioning match upstream one
        # to ease version-based comparisons.
        gcc_base_version=$(< gcc/BASE-VER)
        if [[ ${baseVersion} != $gcc_base_version ]]; then
          echo "Please update 'version' variable:"
          echo "  Expected: '$gcc_base_version'"
          echo "  Actual: '${version}'"
          exit 1
        fi
      ''
      # This should kill all the stdinc frameworks that gcc and friends like to
      # insert into default search paths.
      + optionalString hostPlatform.isDarwin ''
        substituteInPlace gcc/config/darwin-c.cc \
          --replace 'if (stdinc)' 'if (0)'

        substituteInPlace libgcc/config/t-slibgcc-darwin \
          --replace "-install_name @shlib_slibdir@/\$(SHLIB_INSTALL_NAME)" "-install_name ''${!outputLib}/lib/\$(SHLIB_INSTALL_NAME)"

        substituteInPlace libgfortran/configure \
          --replace "-install_name \\\$rpath/\\\$soname" "-install_name ''${!outputLib}/lib/\\\$soname"
      ''
      + (optionalString ((!lib.systems.equals targetPlatform hostPlatform) || stdenv.cc.libc != null)
        # On NixOS, use the right path to the dynamic linker instead of
        # `/lib/ld*.so'.
        (
          let
            libc = if libcCross != null then libcCross else stdenv.cc.libc;
          in
          (
            ''
              echo "fixing the {GLIBC,UCLIBC,MUSL}_DYNAMIC_LINKER macros..."
              for header in "gcc/config/"*-gnu.h "gcc/config/"*"/"*.h
              do
                grep -q _DYNAMIC_LINKER "$header" || continue
                echo "  fixing $header..."
                sed -i "$header" \
                    -e 's|define[[:blank:]]*\([UCG]\+\)LIBC_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define \1LIBC_DYNAMIC_LINKER\2 "${libc.out}\3"|g' \
                    -e 's|define[[:blank:]]*MUSL_DYNAMIC_LINKER\([0-9]*\)[[:blank:]]"\([^\"]\+\)"$|define MUSL_DYNAMIC_LINKER\1 "${libc.out}\2"|g'
                done
            ''
            + optionalString (targetPlatform.libc == "musl") ''
              sed -i gcc/config/linux.h -e '1i#undef LOCAL_INCLUDE_DIR'
            ''
          )
        )
      )
      + optionalString targetPlatform.isAvr (''
        makeFlagsArray+=(
           '-s' # workaround for hitting hydra log limit
           'LIMITS_H_TEST=false'
        )
      '');

      inherit
        noSysDirs
        staticCompiler
        withoutTargetLibc
        libcCross
        crossMingw
        ;

      inherit (callFile ./common/dependencies.nix { })
        depsBuildBuild
        nativeBuildInputs
        depsBuildTarget
        buildInputs
        depsTargetTarget
        ;

      preConfigure = (callFile ./common/pre-configure.nix { }) + ''
        ln -sf ${libxcrypt}/include/crypt.h libsanitizer/sanitizer_common/crypt.h
      '';

      dontDisableStatic = true;

      configurePlatforms = [
        "build"
        "host"
        "target"
      ];

      configureFlags = callFile ./common/configure-flags.nix { inherit targetPrefix; };

      inherit targetConfig;

      buildFlags =
        # we do not yet have Nix-driven profiling
        assert profiledCompiler -> !disableBootstrap;
        let
          target =
            optionalString (profiledCompiler) "profiled"
            + optionalString (
              (lib.systems.equals targetPlatform hostPlatform)
              && (lib.systems.equals hostPlatform buildPlatform)
              && !disableBootstrap
            ) "bootstrap";
        in
        optional (target != "") target;

      inherit (callFile ./common/strip-attributes.nix { })
        stripDebugList
        stripDebugListTarget
        preFixup
        ;

      # https://gcc.gnu.org/PR109898
      enableParallelInstalling = false;

      env = mapAttrs (_: v: toString v) {

        NIX_NO_SELF_RPATH = true;

        # https://gcc.gnu.org/install/specific.html#x86-64-x-solaris210
        ${if hostPlatform.system == "x86_64-solaris" then "CC" else null} = "gcc -m64";

        # Setting $CPATH and $LIBRARY_PATH to make sure both `gcc' and `xgcc' find the
        # library headers and binaries, regardless of the language being compiled.
        #
        # The LTO code doesn't find zlib, so we just add it to $CPATH and
        # $LIBRARY_PATH in this case.
        #
        # Cross-compiling, we need gcc not to read ./specs in order to build the g++
        # compiler (after the specs for the cross-gcc are created). Having
        # LIBRARY_PATH= makes gcc read the specs from ., and the build breaks.

        CPATH = optionals (lib.systems.equals targetPlatform hostPlatform) (
          makeSearchPathOutput "dev" "include" ([ ] ++ optional (zlib != null) zlib)
        );

        LIBRARY_PATH = optionals (lib.systems.equals targetPlatform hostPlatform) (
          makeLibraryPath (optional (zlib != null) zlib)
        );

        NIX_LDFLAGS = optionalString hostPlatform.isSunOS "-lm";

        inherit (callFile ./common/extra-target-flags.nix { })
          EXTRA_FLAGS_FOR_TARGET
          EXTRA_LDFLAGS_FOR_TARGET
          ;
      };

      passthru = {
        inherit
          langC
          langCC
          langObjC
          langObjCpp
          langAda
          langFortran
          langGo
          version
          ;
        isGNU = true;
        hardeningUnsupportedFlags =
          optional (
            !(targetPlatform.isLinux && targetPlatform.isx86_64 && targetPlatform.libc == "glibc")
          ) "shadowstack"
          ++ optional (!(targetPlatform.isLinux && targetPlatform.isAarch64)) "pacret"
          ++ optionals (langFortran) [
            "fortify"
            "format"
          ];
      };

      enableParallelBuilding = true;
      inherit enableShared enableMultilib;

      meta = {
        inherit (callFile ./common/meta.nix { inherit targetPrefix; })
          homepage
          license
          description
          longDescription
          platforms
          teams
          mainProgram
          identifiers
          ;
      };
    }
    // optionalAttrs enableMultilib {
      dontMoveLib64 = true;
    }
  ))
  ([
    (callPackage ./common/libgcc.nix {
      inherit
        version
        langC
        langCC
        langJit
        targetPlatform
        hostPlatform
        withoutTargetLibc
        enableShared
        libcCross
        ;
    })
    (callPackage ./common/checksum.nix { inherit langC langCC; })
  ])
