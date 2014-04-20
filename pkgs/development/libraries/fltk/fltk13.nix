{ composableDerivation, fetchurl, pkgconfig, x11, inputproto, libXi
, freeglut, mesa, libjpeg, zlib, libXinerama, libXft, libpng

, automake, autoconf, libtool
}:

let inherit (composableDerivation) edf; in

let version = "1.3.2"; in
composableDerivation.composableDerivation {} {
  name = "fltk-${version}";

  src = fetchurl {
    url = "http://fltk.org/pub/fltk/${version}/fltk-${version}-source.tar.gz";
    sha256 = "1974brlk723095vf8z72kazq1cbqr9a51kq6b0xda6zkjkgl8q0p";
  };

  propagatedBuildInputs = [ x11 inputproto libXi freeglut ];

  enableParallelBilding = true;

  nativeBuildInputs = [
    pkgconfig
    automake autoconf libtool # only required because of patch
  ];

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

  patches = [
    # https://bugs.archlinux.org/task/36186
    (fetchurl {
    url = "https://bugs.archlinux.org/task/36186?getfile=10750";
    sha256 = "1hpb1i87nc3zw6mgpgf3bfv557ci930bsn6rwlhaif51nlqd2wbj";
  }) ];
}
