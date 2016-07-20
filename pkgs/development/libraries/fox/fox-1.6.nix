{ stdenv, fetchurl, xlibsWrapper, libpng, libjpeg, libtiff, zlib, bzip2, libXcursor
, libXrandr, mesa, libXft, libXfixes, xinput }:

let
  version = "1.6.49";
in

stdenv.mkDerivation rec {
  name = "fox-${version}";

  src = fetchurl {
    url = "ftp://ftp.fox-toolkit.org/pub/${name}.tar.gz";
    sha256 = "03m9wm8hpzh1i0fxx5mpvjr67384pfm9hn7gzdcq55b4639fqy9n";
  };

  buildInputs = [ xlibsWrapper libpng libjpeg libtiff zlib bzip2 libXcursor libXrandr
      libXft mesa libXfixes xinput ];

  doCheck = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    branch = "1.6";
    description = "A C++ based class library for building Graphical User Interfaces";
    longDescription = ''
        FOX stands for Free Objects for X.
        It is a C++ based class library for building Graphical User Interfaces.
        Initially, it was developed for LINUX, but the scope of this project has in the course of time become somewhat more ambitious.
        Current aims are to make FOX completely platform independent, and thus programs written against the FOX library will be only a compile away from running on a variety of platforms.
      '';
    homepage = "http://fox-toolkit.org";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
