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
  addToCheckInputs = pkg: old: {
    checkInputs = (old.checkInputs or [ ]) ++ lib.toList pkg;
  };
  addToNativeCheckInputs = pkg: old: {
    nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ lib.toList pkg;
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
  address-info = {
    # Tests require internet access
    doCheck = false;
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
  crunch = {
    # Tests fail
    doCheck = false;
  };
  egg-tarballs = {
    # To make tests look for the compiled program in PATH instead of at the same directory as csi
    env.SALMONELLA_RUNNING = true;
  };
  espeak = addToBuildInputsWithPkgConfig pkgs.espeak-ng;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.libx11;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  lazy-ffi = addToBuildInputs pkgs.libffi;
  # The egg bundles the leptonica headers it needs, but not the library.
  leptonic = addToBuildInputs pkgs.leptonica;
  leveldb = addToBuildInputs pkgs.leveldb;
  lowdown = addToNativeCheckInputs [
    pkgs.perl
    pkgs.html-tidy
  ];
  memcached = addToNativeCheckInputs pkgs.memcached;
  mpi =
    old:
    (addToBuildInputs pkgs.openmpi old)
    // (addToNativeCheckInputs pkgs.openmpi old)
    // {

      preBuild = ''
        mkdir -p $NIX_BUILD_TOP/mpi-dir
        ln -sf ${lib.getDev pkgs.openmpi}/include $NIX_BUILD_TOP/mpi-dir/include
        ln -sf ${lib.getLib pkgs.openmpi}/lib $NIX_BUILD_TOP/mpi-dir/lib
        export MPI_DIR=$NIX_BUILD_TOP/mpi-dir
      '';
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
  openssl =
    old: (addToBuildInputsWithPkgConfig pkgs.openssl old) // (addToNativeCheckInputs pkgs.openssl old);
  postgresql = addToBuildInputsWithPkgConfig pkgs.libpq;

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
    // (addToCheckInputs chickenEggs.test old)
    // {
      # Tests currently broken
      doCheck = false;
    };

  # pdf-font.scm imports srfi-69, which is no longer a builtin unit in CHICKEN 6.
  pdf = addToBuildInputs chickenEggs.srfi-69;

  raylib = addToBuildInputsWithPkgConfig pkgs.raylib;

  s9fes-char-graphics = addToBuildInputs chickenEggs.srfi-13;
  s9fes-char-graphics-shapes = addToCheckInputs chickenEggs.srfi-13;

  # Unlike the CHICKEN 5 egg, which hardcoded /usr/include/subversion-1, this one
  # asks pkg-config for everything.
  svn-client = addToBuildInputsWithPkgConfig [
    pkgs.subversion
    pkgs.apr
    pkgs.aprutil
  ];

  srfi-19 = {
    # Some tests fail for unknown reasons
    doCheck = false;
  };

  srfi-69-weak = {
    # Some tests fail for unknown reasons
    doCheck = false;
  };

  srfi-160 = {
    # Some tests fail for unknown reasons
    doCheck = false;
  };

  srfi-253 = {
    # Tests cannot be run with chicken-install -test (breaks the same way in salmonella)
    doCheck = false;
  };

  tick =
    old:
    (addToNativeCheckInputs pkgs.git old)
    // {
      preCheck = ''
        export GIT_CONFIG_GLOBAL="$NIX_BUILD_TOP/.gitconfig"
        git config --global user.email "nix@example.com"
        git config --global user.name "Nix Build"
        git config --global init.defaultBranch master
      '';
      postInstall = ''
        wrapProgram $out/bin/tick --prefix PATH : ${pkgs.git}/bin
      '';
    };

  utf8 = addToCheckInputs chickenEggs.test;

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

  # feathers is implemented in Tcl and its .egg declares no source for the
  # program it builds, so chicken-install falls back to a feathers.scm that the
  # tarball does not contain. It only fails here because the egg is built and
  # installed by two separate chicken-install runs. Upstream is deprecating it.
  feathers = broken;
}
