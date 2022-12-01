{ lib
, stdenv
, fetchurl
, libpng
, libjpeg
, libtiff
, zlib
, bzip2
, libXcursor
, libXext
, libXrandr
, libXft
, CoreServices ? null
}:

stdenv.mkDerivation rec {
  pname = "fox";
  version = "1.7.9";

  src = fetchurl {
    url = "ftp://ftp.fox-toolkit.org/pub/${pname}-${version}.tar.gz";
    sha256 = "1jb9368xsin3ppdf6979n5s7in3s9klbxqbwcp0z8misjixl7nzg";
  };

  patches = [ ./clang.patch ];

  buildInputs = [ libpng libjpeg libtiff zlib bzip2 libXcursor libXext libXrandr libXft ]
    ++ lib.optional stdenv.isDarwin CoreServices;

  doCheck = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "C++ based class library for building Graphical User Interfaces";
    longDescription = ''
      FOX stands for Free Objects for X.
      It is a C++ based class library for building Graphical User Interfaces.
      Initially, it was developed for LINUX, but the scope of this project has in the course of time become somewhat more ambitious.
      Current aims are to make FOX completely platform independent, and thus programs written against the FOX library will be only a compile away from running on a variety of platforms.
    '';
    homepage = "http://fox-toolkit.org";
    license = licenses.lgpl3;
    maintainers = [];
    broken = stdenv.isDarwin && stdenv.isAarch64;
    platforms = platforms.all;
  };
}
