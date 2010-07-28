{ composableDerivation, fetchurl, pkgconfig, x11, inputproto, libXi
, freeglut, mesa, libjpeg, zlib, libXinerama, libXft, libpng }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {
  name = "fltk-1.1.10";

  src = fetchurl {
    url = http://ftp.rz.tu-bs.de/pub/mirror/ftp.easysw.com/ftp/pub/fltk/1.1.10/fltk-1.1.10-source.tar.bz2;
    sha256 = "16mic69a48y3ybijml754x38djxxb25rn8441p9qsssqy8ms5b9p";
  };

  propagatedBuildInputs = [ x11 inputproto libXi freeglut ];

  buildInputs = [ pkgconfig ];

  flags =
    # this could be tidied up (?).. eg why does it require freeglut without glSupport?
    edf { name = "cygwin"; }  #         use the CygWin libraries default=no
    // edf { name = "debug"; }  #          turn on debugging default=no
    // edf { name = "gl"; enable = { buildInputs = [ mesa ]; }; }  #             turn on OpenGL support default=yes
    // edf { name = "shared"; }  #         turn on shared libraries default=no
    // edf { name = "threads"; }  #        enable multi-threading support
    // edf { name = "quartz"; enable = { buildInputs = "quartz"; }; }  # don't konw yet what quartz is #         use Quartz instead of Quickdraw (default=no)
    // edf { name = "largefile"; } #     omit support for large files
    // edf { name = "localjpeg"; disable = { buildInputs = [libjpeg]; }; } #       use local JPEG library, default=auto
    // edf { name = "localzlib"; disable = { buildInputs = [zlib]; }; } #       use local ZLIB library, default=auto
    // edf { name = "localpng"; disable = { buildInputs = [libpng]; }; } #       use local PNG library, default=auto
    // edf { name = "xinerama"; enable = { buildInputs = [libXinerama]; }; } #       turn on Xinerama support default=no
    // edf { name = "xft"; enable = { buildInputs=[libXft]; }; } #            turn on Xft support default=no
    // edf { name = "xdbe"; };  #           turn on Xdbe support default=no

  cfg = {
    largefileSupport = true; # is default
    glSupport = true; # doesn't build without it. Why?
    localjpegSupport = false;
    localzlibSupport = false;
    localpngSupport = false;
    sharedSupport = true;
    threadsSupport = true;
  };

  meta = {
    description = "A C++ cross-platform light-weight GUI library binding";
    homepage = http://www.fltk.org;
  };
}
