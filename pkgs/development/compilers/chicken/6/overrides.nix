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
  espeak = addToBuildInputsWithPkgConfig pkgs.espeak-ng;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.libx11;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
  lazy-ffi = addToBuildInputs pkgs.libffi;
  # The egg bundles the leptonica headers it needs, but not the library.
  leptonic = addToBuildInputs pkgs.leptonica;
  leveldb = addToBuildInputs pkgs.leveldb;
  mpi =
    old:
    (addToBuildInputs pkgs.openmpi old)
    // {
      preBuild = ''
        mkdir -p $NIX_BUILD_TOP/mpi-dir
        ln -sf ${lib.getDev pkgs.openmpi}/include $NIX_BUILD_TOP/mpi-dir/include
        ln -sf ${lib.getLib pkgs.openmpi}/lib $NIX_BUILD_TOP/mpi-dir/lib
        export MPI_DIR=$NIX_BUILD_TOP/mpi-dir
      '';
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
  openssl = addToBuildInputs pkgs.openssl;
  postgresql = addToBuildInputsWithPkgConfig pkgs.libpq;
  raylib = addToBuildInputsWithPkgConfig pkgs.raylib;
  sqlite3 = addToBuildInputs pkgs.sqlite;
  uuid-lib = addToBuildInputs pkgs.libuuid;

  # Missing dependencies in the upstream eggs.
  # s9fes.draw-tree imports srfi-13.
  s9fes-char-graphics = addToPropagatedBuildInputs chickenEggs.srfi-13;
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

  # Unlike the CHICKEN 5 egg, which hardcoded /usr/include/subversion-1, this one
  # asks pkg-config for everything.
  svn-client = addToBuildInputsWithPkgConfig [
    pkgs.subversion
    pkgs.apr
    pkgs.aprutil
  ];

  # Mark broken.
  # nutils calls mempcpy, which is a GNU extension that Darwin's libc does not
  # provide, and tkgui depends on nutils.
  nutils = brokenOnDarwin;
  tkgui = brokenOnDarwin;

  # "Error: extension is not targeted for this system: \"inotify\""
  inotify = brokenOnDarwin;
  # fatal error: 'omp.h' file not found
  fusion-arrays = brokenOnDarwin;
  # fatal error: 'mqueue.h' file not found
  posix-mq = brokenOnDarwin;
  # ld: library not found for -lrt
  posix-shm = brokenOnDarwin;

  # Unresolved identifiers: the egg is not CHICKEN 6 compatible.
  spiffy-uri-match = broken;
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
