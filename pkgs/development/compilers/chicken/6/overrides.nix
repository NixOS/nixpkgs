{
  stdenv,
  pkgs,
  lib,
  chickenEggs,
}:
let
  inherit (lib) addMetaAttrs;
  addToNativeBuildInputs = pkg: old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ lib.toList pkg;
  };
  addToBuildInputs = pkg: old: {
    buildInputs = (old.buildInputs or [ ]) ++ lib.toList pkg;
  };
  addToPropagatedBuildInputs = pkg: old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ lib.toList pkg;
  };
  addToInstallCheckInputs = pkg: old: {
    installCheckInputs = (old.installCheckInputs or [ ]) ++ lib.toList pkg;
  };
  addToNativeInstallCheckInputs = pkg: old: {
    nativeInstallCheckInputs = (old.nativeInstallCheckInputs or [ ]) ++ lib.toList pkg;
  };
  addPkgConfig = old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
  };
  addToBuildInputsWithPkgConfig = pkg: old: (addPkgConfig old) // (addToBuildInputs pkg old);
  addToCscOptions = opt: old: {
    env.CSC_OPTIONS = lib.concatStringsSep " " ([ old.env.CSC_OPTIONS or "" ] ++ lib.toList opt);
  };
  broken = addMetaAttrs { broken = true; };
  brokenOnDarwin = addMetaAttrs { broken = stdenv.hostPlatform.isDarwin; };
in
{
  # Upstream builds its components only for the host, for compiling against,
  # which leaves it empty when cross-compiling, yet the eggs using it load it
  # at run time, so it is built for the target, too.
  bind =
    old:
    lib.optionalAttrs (!lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform) {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace bind.egg \
          --replace-fail "(host" "" \
          --replace-fail "(component-dependencies bind-translator)))))" "(component-dependencies bind-translator))))"
      '';
    };

  address-info = {
    # Tests require internet access
    doInstallCheck = false;
  };
  # Eggs binding to a native library.
  blas = addToBuildInputsWithPkgConfig pkgs.blas;
  breadline = addToBuildInputs pkgs.readline;
  # The egg binds to iconv, which is part of glibc but a library of its own on
  # Darwin, where the bundle it produces has to resolve every symbol at link
  # time rather than at load time.
  bvconv =
    old:
    (addToBuildInputs (lib.optional stdenv.hostPlatform.isDarwin pkgs.libiconv) old)
    // lib.optionalAttrs stdenv.hostPlatform.isDarwin (addToCscOptions "-L -liconv" old);
  cairo = addToBuildInputsWithPkgConfig pkgs.cairo;
  cmark = addToBuildInputs pkgs.cmark;
  crypt =
    old:
    (addToBuildInputs pkgs.libxcrypt old)
    # When cross-compiling, the build script cannot run its probe of which hash
    # types crypt() supports, so they are forced to those libxcrypt is built
    # with, which the probe would find. The DES ones have no scheme id, so the
    # egg always provides those.
    // lib.optionalAttrs (!lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform) {
      env =
        let
          hashTypes = {
            "2a" = "blowfish";
            "6" = "sha512";
            "5" = "sha256";
            "1" = "md5";
          };
        in
        (old.env or { })
        // {
          FORCE_CRYPT_HASHTYPES = toString (
            map (id: hashTypes.${id}) (lib.filter (id: hashTypes ? ${id}) pkgs.libxcrypt.enabledCryptSchemeIds)
          );
        };
      # The build script also compiles the import library for the build
      # platform, which the compiler for the target cannot do; the one for the
      # target is built separately anyway.
      postPatch = (old.postPatch or "") + ''
        substituteInPlace build-crypt.scm \
          --replace-fail '(compile-file "crypt.import.scm" #:options `("-s" "-O2"))' ""
      '';
    };
  crunch = {
    # Tests fail
    doInstallCheck = false;
  };
  egg-tarballs = {
    # To make tests look for the compiled program in PATH instead of at the same directory as csi
    env.SALMONELLA_RUNNING = true;
  };
  espeak = addToBuildInputsWithPkgConfig pkgs.espeak-ng;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.libx11;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
  lazy-ffi = addToBuildInputs pkgs.libffi;
  # The egg bundles the leptonica headers it needs, but not the library.
  leptonic = addToBuildInputs pkgs.leptonica;
  leveldb = addToBuildInputs pkgs.leveldb;
  lowdown = addToNativeInstallCheckInputs [
    pkgs.perl
    pkgs.html-tidy
  ];
  memcached = addToNativeInstallCheckInputs pkgs.memcached;
  mpi =
    old:
    (addToBuildInputs pkgs.openmpi old)
    // (addToNativeInstallCheckInputs pkgs.openmpi old)
    // {
      preBuild = ''
        mkdir -p $NIX_BUILD_TOP/mpi-dir
        ln -sf ${lib.getDev pkgs.openmpi}/include $NIX_BUILD_TOP/mpi-dir/include
        ln -sf ${lib.getLib pkgs.openmpi}/lib $NIX_BUILD_TOP/mpi-dir/lib
        export MPI_DIR=$NIX_BUILD_TOP/mpi-dir
      '';
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

      # Some tests fail due to number parsing precision changes in CHICKEN 6.1.0
      doInstallCheck = false;
    };
  openssl =
    old:
    (addToBuildInputsWithPkgConfig pkgs.openssl old)
    // (addToNativeInstallCheckInputs pkgs.openssl old)
    // {
      preInstallCheck = ''
        export TMPDIR=$NIX_BUILD_TOP/tmp
        mkdir -p $TMPDIR
      '';
      # Tests fail due to a bug in C6.
      # Error: (file-mkstemps) cannot create temporary file - Invalid argument: "/build/tmp/tempXXXXXX.conf"
      doInstallCheck = false;
    };
  pdfa = {
    # Warning: error in group outside of tests
    #
    # Error: (write-pdfa-document) document does not conform to PDF/A-1b:
    #   no output intent: call set-output-intent! with an ICC profile (6.2.2)
    doInstallCheck = false;
  };
  postgresql = addToBuildInputsWithPkgConfig pkgs.libpq;
  raylib = addToBuildInputsWithPkgConfig pkgs.raylib;
  salt = {
    # Tests reference deprecated chicken-home
    doInstallCheck = false;
  };
  sqlite3 = addToBuildInputs pkgs.sqlite;
  uuid-lib = addToBuildInputs pkgs.libuuid;

  # Missing dependencies in the upstream eggs.
  # chicken.blob is no longer part of CHICKEN 6, but is provided by the
  # chicken-blob egg.
  aes = addToPropagatedBuildInputs chickenEggs.chicken-blob;
  crypto-tools = addToPropagatedBuildInputs chickenEggs.chicken-blob;
  lmdb-ht =
    old: (addToBuildInputs pkgs.lmdb old) // (addToPropagatedBuildInputs chickenEggs.chicken-blob old);

  # fltk-config has to be on PATH: the egg runs it to get its compiler flags.
  # Those flags include -lGL and -lGLU, which fltk does not pull in itself.
  bb =
    old:
    (addToBuildInputs [
      pkgs.fltk
      pkgs.libGL
      pkgs.libGLU
    ] old)
    // (addToNativeBuildInputs pkgs.fltk old);

  # The egg looks for the OpenCASCADE headers in /usr/{local/,}include/opencascade,
  # which the C compiler wrapper cannot make up for, as they are in a subdirectory
  # of the include path it is given. It also names every OpenCASCADE library it
  # needs except TKBO, which defines the BRepAlgoAPI_* boolean operations it calls;
  # on Linux that library still arrives, as a transitive dependency of TKBool, but
  # a Darwin bundle has to name it.
  constructive-solid-geometry =
    old:
    (addToBuildInputs pkgs.opencascade-occt old)
    // (addToCscOptions [
      "-C -I${lib.getDev pkgs.opencascade-occt}/include/opencascade"
      "-L -lTKBO"
    ] old);

  nutils =
    old:
    # nutils calls mempcpy, which is a GNU extension that Darwin's libc does not provide, and tkgui
    # depends on nutils.
    (brokenOnDarwin old)
    // (addToInstallCheckInputs chickenEggs.test old)
    // {
      # Tests currently broken
      doInstallCheck = false;
    };

  # pdf-font.scm imports srfi-69, which is no longer a builtin unit in CHICKEN 6.
  pdf = addToBuildInputs chickenEggs.srfi-69;

  # Unlike the CHICKEN 5 egg, which hardcoded /usr/include/subversion-1, this one
  # asks pkg-config for everything.
  svn-client = addToBuildInputsWithPkgConfig [
    pkgs.subversion
    pkgs.apr
    pkgs.aprutil
  ];

  srfi-19 = {
    # Some tests fail for unknown reasons
    doInstallCheck = false;
  };

  srfi-69-weak = {
    # Some tests fail for unknown reasons
    doInstallCheck = false;
  };

  srfi-160 = {
    # Some tests fail for unknown reasons
    doInstallCheck = false;
  };

  srfi-180 = {
    # See https://lists.nongnu.org/archive/html/chicken-users/2026-11/msg00018.html
    postPatch = ''
      rm tests/files/i_number_huge_exp.json
    '';
  };

  srfi-253 = {
    # Tests cannot be run with chicken-install -test (breaks the same way in salmonella)
    doInstallCheck = false;
  };

  tick =
    old:
    (addToNativeInstallCheckInputs pkgs.git old)
    // {
      preInstallCheck = ''
        export GIT_CONFIG_GLOBAL="$NIX_BUILD_TOP/.gitconfig"
        git config --global user.email "nix@example.com"
        git config --global user.name "Nix Build"
        git config --global init.defaultBranch master
      '';
      postInstall = ''
        wrapProgram $out/bin/tick --prefix PATH : ${pkgs.git}/bin
      '';
    };

  utf8 = addToInstallCheckInputs chickenEggs.test;

  # Transitively broken via nutils
  tkgui = brokenOnDarwin;

  # "Error: extension is not targeted for this system: \"inotify\""
  inotify = brokenOnDarwin;
  # fatal error: 'omp.h' file not found
  fusion-arrays = brokenOnDarwin;
  # fatal error: 'mqueue.h' file not found
  posix-mq = brokenOnDarwin;
  # ld: library not found for -lrt
  posix-shm = brokenOnDarwin;

  # chicken.compiler.support#read/source-info no longer exists.
  begin-syntax = broken;
  # chicken-home is no longer exported by chicken.platform.
  chicken-doc = broken;
  # "Cannot combine block compilation mode with emitting import libraries"
  matchertext = broken;

  # feathers is implemented in Tcl and its .egg declares no source for the
  # program it builds, so chicken-install falls back to a feathers.scm that the
  # tarball does not contain. It only fails here because the egg is built and
  # installed by two separate chicken-install runs. Upstream is deprecating it.
  feathers = broken;
}
