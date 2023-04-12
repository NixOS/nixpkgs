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
  brokenOnDarwin = old: { meta = old.meta // { broken = stdenv.isDarwin; }; };
in {
  allegro = addToBuildInputsWithPkgConfig [ pkgs.allegro5 pkgs.libglvnd ];
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
  exif = old: (brokenOnDarwin old) // (addToBuildInputs pkgs.libexif old);
  expat = addToBuildInputs pkgs.expat;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.xorg.libX11;
  freetype = addToBuildInputs pkgs.freetype;
  fuse = addToBuildInputsWithPkgConfig pkgs.fuse;
  git = addToBuildInputsWithPkgConfig pkgs.libgit2;
  glfw3 = addToBuildInputsWithPkgConfig pkgs.glfw3;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
  lazy-ffi = addToBuildInputs pkgs.libffi;
  leveldb = addToBuildInputs pkgs.leveldb;
  magic = addToBuildInputs pkgs.file;
  mdh = addToBuildInputs pkgs.pcre;
  nanomsg = addToBuildInputs pkgs.nanomsg;
  ncurses = addToBuildInputsWithPkgConfig [ pkgs.ncurses ];
  opencl = addToBuildInputs [ pkgs.opencl-headers pkgs.ocl-icd ];
  opengl = addToBuildInputsWithPkgConfig [ pkgs.libGL pkgs.libGLU ];
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
  stfl = addToBuildInputs [ pkgs.ncurses pkgs.stfl ];
  taglib = old:
    (brokenOnDarwin old) // (addToBuildInputs [ pkgs.zlib pkgs.taglib ] old);
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
  F-operator = old: { meta = old.meta // { broken = true; }; };
  comparse = old: { meta = old.meta // { broken = true; }; };
  kiwi = old: { meta = old.meta // { broken = true; }; };
  qt-light = old: { meta = old.meta // { broken = true; }; };
  stty = brokenOnDarwin;
}
