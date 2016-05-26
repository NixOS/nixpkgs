{ stdenv, composableDerivation, fetchurl, pkgconfig, xlibsWrapper, inputproto, libXi
, freeglut, mesa, libjpeg, zlib, libXinerama, libXft, libpng
, cfg ? {}
}:

let inherit (composableDerivation) edf; in

let version = "1.3.3"; in
composableDerivation.composableDerivation {} {
  name = "fltk-${version}";

  src = fetchurl {
    url = "http://fltk.org/pub/fltk/${version}/fltk-${version}-source.tar.gz";
    sha256 = "15qd7lkz5d5ynz70xhxhigpz3wns39v9xcf7ggkl0792syc8sfgq";
  };

  # http://www.fltk.org/str.php?L3156
  postPatch = ''
    substituteInPlace FL/x.H \
      --replace 'class Fl_XFont_On_Demand' 'class FL_EXPORT Fl_XFont_On_Demand'
  '';

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ xlibsWrapper inputproto libXi freeglut ];

  enableParallelBuilding = true;

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
    xftSupport = true;
  } // cfg;

  meta = {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = http://www.fltk.org;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };

}

