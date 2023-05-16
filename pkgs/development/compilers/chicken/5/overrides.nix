{ stdenv, pkgs, lib, chickenEggs }:
let
<<<<<<< HEAD
  inherit (lib) addMetaAttrs;
  addToNativeBuildInputs = pkg: old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ lib.toList pkg;
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  addToBuildInputs = pkg: old: {
    buildInputs = (old.buildInputs or [ ]) ++ lib.toList pkg;
  };
  addToPropagatedBuildInputs = pkg: old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
      ++ lib.toList pkg;
  };
  addPkgConfig = old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
  };
  addToBuildInputsWithPkgConfig = pkg: old:
    (addPkgConfig old) // (addToBuildInputs pkg old);
  addToPropagatedBuildInputsWithPkgConfig = pkg: old:
    (addPkgConfig old) // (addToPropagatedBuildInputs pkg old);
<<<<<<< HEAD
  broken = addMetaAttrs { broken = true; };
  brokenOnDarwin = addMetaAttrs { broken = stdenv.isDarwin; };
  addToCscOptions = opt: old: {
    CSC_OPTIONS = lib.concatStringsSep " " ([ old.CSC_OPTIONS or "" ] ++ lib.toList opt);
  };
in
{
=======
  broken = old: { meta = old.meta // { broken = true; }; };
  brokenOnDarwin = old: { meta = old.meta // { broken = stdenv.isDarwin; }; };
in {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  allegro = addToBuildInputsWithPkgConfig ([ pkgs.allegro5 pkgs.libglvnd ]
    ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.OpenGL ]);
  breadline = addToBuildInputs pkgs.readline;
  blas = addToBuildInputsWithPkgConfig pkgs.blas;
  blosc = addToBuildInputs pkgs.c-blosc;
<<<<<<< HEAD
  botan = addToBuildInputsWithPkgConfig pkgs.botan2;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cairo = old:
    (addToBuildInputsWithPkgConfig pkgs.cairo old)
    // (addToPropagatedBuildInputs (with chickenEggs; [ srfi-1 srfi-13 ]) old);
  cmark = addToBuildInputs pkgs.cmark;
  dbus = addToBuildInputsWithPkgConfig pkgs.dbus;
  epoxy = addToPropagatedBuildInputsWithPkgConfig pkgs.libepoxy;
  espeak = addToBuildInputsWithPkgConfig pkgs.espeak-ng;
  exif = addToBuildInputsWithPkgConfig pkgs.libexif;
  expat = addToBuildInputsWithPkgConfig pkgs.expat;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.xorg.libX11;
  freetype = addToBuildInputsWithPkgConfig pkgs.freetype;
  fuse = addToBuildInputsWithPkgConfig pkgs.fuse;
<<<<<<< HEAD
=======
  # git = addToBuildInputsWithPkgConfig pkgs.libgit2;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  gl-utils = addPkgConfig;
  glfw3 = addToBuildInputsWithPkgConfig pkgs.glfw3;
  glls = addPkgConfig;
  iconv = addToBuildInputs (lib.optional stdenv.isDarwin pkgs.libiconv);
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
<<<<<<< HEAD
  inotify = old:
    (addToBuildInputs (lib.optional stdenv.isDarwin pkgs.libinotify-kqueue) old)
    // lib.optionalAttrs stdenv.isDarwin (addToCscOptions "-L -linotify" old);
=======
  lazy-ffi = old:
    # fatal error: 'ffi/ffi.h' file not found
    (brokenOnDarwin old)
    // (addToBuildInputs pkgs.libffi old);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  leveldb = addToBuildInputs pkgs.leveldb;
  magic = addToBuildInputs pkgs.file;
  mdh = addToBuildInputs pkgs.pcre;
  nanomsg = addToBuildInputs pkgs.nanomsg;
  ncurses = addToBuildInputsWithPkgConfig [ pkgs.ncurses ];
  opencl = addToBuildInputs ([ pkgs.opencl-headers pkgs.ocl-icd ]
    ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.OpenCL ]);
<<<<<<< HEAD
=======
  opengl = old:
    # csc: invalid option `-framework OpenGL'
    (brokenOnDarwin old)
    // (addToBuildInputsWithPkgConfig [ pkgs.libGL pkgs.libGLU ] old);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  openssl = addToBuildInputs pkgs.openssl;
  plot = addToBuildInputs pkgs.plotutils;
  postgresql = addToBuildInputsWithPkgConfig pkgs.postgresql;
  rocksdb = addToBuildInputs pkgs.rocksdb;
<<<<<<< HEAD
  scheme2c-compatibility = old:
    addToNativeBuildInputs (lib.optionals (stdenv.system == "x86_64-darwin") [ pkgs.memorymappingHook ])
      (addPkgConfig old);
=======
  scheme2c-compatibility = addPkgConfig;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  sdl-base = addToBuildInputs pkgs.SDL;
  sdl2 = addToPropagatedBuildInputsWithPkgConfig pkgs.SDL2;
  sdl2-image = addToBuildInputs pkgs.SDL2_image;
  sdl2-ttf = addToBuildInputs pkgs.SDL2_ttf;
  soil = addToPropagatedBuildInputsWithPkgConfig pkgs.libepoxy;
  sqlite3 = addToBuildInputs pkgs.sqlite;
  stemmer = old:
<<<<<<< HEAD
    (addToBuildInputs pkgs.libstemmer old)
    // (addToCscOptions "-L -lstemmer" old);
  stfl = old:
    (addToBuildInputs [ pkgs.ncurses pkgs.stfl ] old)
    // (addToCscOptions "-L -lncurses" old);
=======
    # Undefined symbols for architecture arm64: "_sb_stemmer_delete"
    (brokenOnDarwin old)
    // (addToBuildInputs pkgs.libstemmer old);
  stfl = old:
    # Undefined symbols for architecture arm64: "_clearok"
    (brokenOnDarwin old)
    // (addToBuildInputs [ pkgs.ncurses pkgs.stfl ] old);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  taglib = addToBuildInputs [ pkgs.zlib pkgs.taglib ];
  uuid-lib = addToBuildInputs pkgs.libuuid;
  ws-client = addToBuildInputs pkgs.zlib;
  xlib = addToPropagatedBuildInputs pkgs.xorg.libX11;
  yaml = addToBuildInputs pkgs.libyaml;
  zlib = addToBuildInputs pkgs.zlib;
  zmq = addToBuildInputs pkgs.zeromq;
  zstd = addToBuildInputs pkgs.zstd;

<<<<<<< HEAD
  # less trivial fixes, should be upstreamed
  git = old: (addToBuildInputsWithPkgConfig pkgs.libgit2 old) // {
    postPatch = ''
      substituteInPlace libgit2.scm \
        --replace "asize" "reserved"
    '';
  };
  lazy-ffi = old: (addToBuildInputs pkgs.libffi old) // {
    postPatch = ''
      substituteInPlace lazy-ffi.scm \
        --replace "ffi/ffi.h" "ffi.h"
    '';
  };
  opengl = old:
    (addToBuildInputsWithPkgConfig
      (lib.optionals (!stdenv.isDarwin) [ pkgs.libGL pkgs.libGLU ]
      ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Foundation pkgs.darwin.apple_sdk.frameworks.OpenGL ])
      old)
    // {
      postPatch = ''
        substituteInPlace opengl.egg \
          --replace 'framework ' 'framework" "'
      '';
    };
  posix-shm = old: {
    postPatch = lib.optionalString stdenv.isDarwin ''
      substituteInPlace build.scm \
        --replace "-lrt" ""
    '';
  };

  # platform changes
  pledge = addMetaAttrs { platforms = lib.platforms.openbsd; };
  unveil = addMetaAttrs { platforms = lib.platforms.openbsd; };
=======
  # platform changes
  pledge = old: { meta = old.meta // { platforms = lib.platforms.openbsd; }; };
  unveil = old: { meta = old.meta // { platforms = lib.platforms.openbsd; }; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # mark broken
  "ephem-v1.1" = broken;
  F-operator = broken;
  atom = broken;
  begin-syntax = broken;
  canvas-draw = broken;
  chicken-doc-admin = broken;
  comparse = broken;
  coops-utils = broken;
  crypt = broken;
<<<<<<< HEAD
=======
  git = broken;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  hypergiant = broken;
  iup = broken;
  kiwi = broken;
  lmdb-ht = broken;
  lsp-server = broken;
  mpi = broken;
  pyffi = broken;
  qt-light = broken;
  salmonella-html-report = broken;
  sundials = broken;
  svn-client = broken;
  system = broken;
  tokyocabinet = broken;
  transducers = broken;
  webview = broken;

  # mark broken darwin

<<<<<<< HEAD
  # fatal error: 'mqueue.h' file not found
  posix-mq = brokenOnDarwin;
=======
  # fatal error: 'sys/inotify.h' file not found
  inotify = brokenOnDarwin;
  # fatal error: 'mqueue.h' file not found
  posix-mq = brokenOnDarwin;
  # ld: library not found for -lrt
  posix-shm = brokenOnDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Undefined symbols for architecture arm64: "_pthread_setschedprio"
  pthreads = brokenOnDarwin;
  # error: use of undeclared identifier 'B4000000'
  stty = brokenOnDarwin;
}
