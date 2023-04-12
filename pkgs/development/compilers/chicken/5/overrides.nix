{ stdenv, pkgs, lib, chickenEggs }:
let
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
  broken = old: { meta = old.meta // { broken = true; }; };
  brokenOnDarwin = old: { meta = old.meta // { broken = stdenv.isDarwin; }; };
in {
  allegro = addToBuildInputsWithPkgConfig ([ pkgs.allegro5 pkgs.libglvnd ]
    ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.OpenGL ]);
  breadline = addToBuildInputs pkgs.readline;
  blas = addToBuildInputsWithPkgConfig pkgs.blas;
  blosc = addToBuildInputs pkgs.c-blosc;
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
  # git = addToBuildInputsWithPkgConfig pkgs.libgit2;
  glfw3 = addToBuildInputsWithPkgConfig pkgs.glfw3;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
  lazy-ffi = old: (brokenOnDarwin old) // (addToBuildInputs pkgs.libffi old);
  leveldb = addToBuildInputs pkgs.leveldb;
  magic = addToBuildInputs pkgs.file;
  mdh = old: (brokenOnDarwin old) // (addToBuildInputs pkgs.pcre old);
  nanomsg = addToBuildInputs pkgs.nanomsg;
  ncurses = addToBuildInputsWithPkgConfig [ pkgs.ncurses ];
  opencl = addToBuildInputs ([ pkgs.opencl-headers pkgs.ocl-icd ]
    ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.OpenCL ]);
  opengl = old:
    (brokenOnDarwin old)
    // (addToBuildInputsWithPkgConfig [ pkgs.libGL pkgs.libGLU ] old);
  openssl = addToBuildInputs pkgs.openssl;
  plot = addToBuildInputs pkgs.plotutils;
  postgresql = addToBuildInputsWithPkgConfig pkgs.postgresql;
  rocksdb = addToBuildInputs pkgs.rocksdb;
  sdl-base = addToBuildInputs pkgs.SDL;
  sdl2 = addToPropagatedBuildInputsWithPkgConfig pkgs.SDL2;
  sdl2-image = addToBuildInputs pkgs.SDL2_image;
  sdl2-ttf = addToBuildInputs pkgs.SDL2_ttf;
  soil = addToPropagatedBuildInputsWithPkgConfig pkgs.libepoxy;
  sqlite3 = addToBuildInputs pkgs.sqlite;
  stemmer = old: (brokenOnDarwin old) // (addToBuildInputs pkgs.libstemmer old);
  stfl = old:
    (brokenOnDarwin old) // (addToBuildInputs [ pkgs.ncurses pkgs.stfl ] old);
  taglib = addToBuildInputs [ pkgs.zlib pkgs.taglib ];
  uuid-lib = addToBuildInputs pkgs.libuuid;
  ws-client = addToBuildInputs pkgs.zlib;
  xlib = addToPropagatedBuildInputs pkgs.xorg.libX11;
  yaml = addToBuildInputs pkgs.libyaml;
  zlib = addToBuildInputs pkgs.zlib;
  zmq = addToBuildInputs pkgs.zeromq;
  zstd = addToBuildInputs pkgs.zstd;

  # platform changes
  pledge = old: { meta = old.meta // { platforms = lib.platforms.openbsd; }; };
  unveil = old: { meta = old.meta // { platforms = lib.platforms.openbsd; }; };

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
  git = broken;
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
  gl-utils = brokenOnDarwin;
  iconv = brokenOnDarwin;
  inotify = brokenOnDarwin;
  posix-mq = brokenOnDarwin;
  posix-shm = brokenOnDarwin;
  pthreads = brokenOnDarwin;
  rbf = brokenOnDarwin;
  scheme2c-compatibility = brokenOnDarwin;
  stty = brokenOnDarwin;
}
