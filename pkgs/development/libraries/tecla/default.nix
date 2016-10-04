{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tecla-1.6.2";

  src = fetchurl {
    url = "http://www.astro.caltech.edu/~mcs/tecla/lib${name}.tar.gz";
    sha256 = "1f5p1v9ac5r1f6pjzwacb4yf8m6z19rv77p76j7fix34hd9dnqcc";
  };

  configureFlags = "CFLAGS=-O3 CXXFLAGS=-O3";

  meta = {
    homepage = "http://www.astro.caltech.edu/~mcs/tecla/";
    description = "Command-line editing library";
    license = "as-is";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
