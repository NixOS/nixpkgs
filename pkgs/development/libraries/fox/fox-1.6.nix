{ lib, stdenv, fetchurl, xlibsWrapper, libpng, libjpeg, libtiff, zlib, bzip2, libXcursor
, libXrandr, libGLU, libGL, libXft, libXfixes, xinput
, CoreServices }:

let
  version = "1.6.57";
in

stdenv.mkDerivation rec {
  pname = "fox";
  inherit version;

  src = fetchurl {
    url = "ftp://ftp.fox-toolkit.org/pub/${pname}-${version}.tar.gz";
    sha256 = "08w98m6wjadraw1pi13igzagly4b2nfa57kdqdnkjfhgkvg1bvv5";
  };

  buildInputs = [
    xlibsWrapper libpng libjpeg libtiff zlib bzip2 libXcursor libXrandr
    libXft libGLU libGL libXfixes xinput
  ] ++ lib.optional stdenv.isDarwin CoreServices;

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
    license = lib.licenses.lgpl3;
    maintainers = [];
    platforms = lib.platforms.mesaPlatforms;
  };
}
