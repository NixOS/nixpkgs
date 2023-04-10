{ pkgs, lib, chickenEggs }:
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
in {
  breadline = addToBuildInputs pkgs.readline;
  cairo = old:
    (addToBuildInputsWithPkgConfig pkgs.cairo old)
    // (addToPropagatedBuildInputs (with chickenEggs; [ srfi-1 srfi-13 ]) old);
  cmark = addToBuildInputs pkgs.cmark;
  dbus = addToBuildInputsWithPkgConfig pkgs.dbus;
  epoxy = addToPropagatedBuildInputsWithPkgConfig pkgs.libepoxy;
  exif = addToBuildInputs pkgs.libexif;
  expat = addToBuildInputs pkgs.expat;
  ezxdisp = addToBuildInputsWithPkgConfig pkgs.xorg.libX11;
  freetype = addToBuildInputs pkgs.freetype;
  glfw3 = addToBuildInputsWithPkgConfig pkgs.glfw3;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
  lazy-ffi = addToBuildInputs pkgs.libffi;
  leveldb = addToBuildInputs pkgs.leveldb;
  magic = addToBuildInputs pkgs.file;
  mdh = addToBuildInputs pkgs.pcre;
  nanomsg = addToBuildInputs pkgs.nanomsg;
  openssl = addToBuildInputs pkgs.openssl;
  rocksdb = addToBuildInputs pkgs.rocksdb;
  sdl-base = addToBuildInputs pkgs.SDL;
  sdl2 = addToPropagatedBuildInputsWithPkgConfig pkgs.SDL2;
  sdl2-image = addToBuildInputs pkgs.SDL2_image;
  sdl2-ttf = addToBuildInputs pkgs.SDL2_ttf;
  sqlite3 = addToBuildInputs pkgs.sqlite;
  stemmer = addToBuildInputs pkgs.libstemmer;
  stfl = addToBuildInputs [ pkgs.ncurses pkgs.stfl ];
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
}
