{ stdenv, fetchurl, xlibsWrapper, libpng, libjpeg, libtiff, zlib, bzip2, libXcursor, libXrandr, libXft
, CoreServices ? null }:

let
  version = "1.7.9";
in

stdenv.mkDerivation rec {
  name = "fox-${version}";

  src = fetchurl {
    url = "ftp://ftp.fox-toolkit.org/pub/${name}.tar.gz";
    sha256 = "1jb9368xsin3ppdf6979n5s7in3s9klbxqbwcp0z8misjixl7nzg";
  };

  buildInputs = [ libpng xlibsWrapper libjpeg libtiff zlib bzip2 libXcursor libXrandr libXft ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  doCheck = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    description = "C++ based class library for building Graphical User Interfaces";
    longDescription = ''
        FOX stands for Free Objects for X.
        It is a C++ based class library for building Graphical User Interfaces.
        Initially, it was developed for LINUX, but the scope of this project has in the course of time become somewhat more ambitious.
        Current aims are to make FOX completely platform independent, and thus programs written against the FOX library will be only a compile away from running on a variety of platforms.
      '';
    homepage = "http://fox-toolkit.org";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.all;
  };
}
