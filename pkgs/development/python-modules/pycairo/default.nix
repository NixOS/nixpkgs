{ stdenv, fetchurl, python, pkgconfig, cairo, x11 }:

stdenv.mkDerivation rec {
  version = "1.10.0";
  name = "pycairo-${version}";
  src = if python.is_py3k or false
    then fetchurl {
      url = "http://cairographics.org/releases/pycairo-${version}.tar.bz2";
      sha256 = "1gjkf8x6hyx1skq3hhwcbvwifxvrf9qxis5vx8x5igmmgs70g94s";
    }
    else fetchurl {
      url = "http://cairographics.org/releases/py2cairo-${version}.tar.bz2";
      sha256 = "0cblk919wh6w0pgb45zf48xwxykfif16qk264yga7h9fdkq3j16k";
    };

  buildInputs = [ python pkgconfig cairo x11 ];
  preConfigure = ''
    sed -e 's@#!/usr/bin/env python@#!${python.executable}@' -i waf
    head waf
  '';
  configurePhase = "${python.executable} waf configure --prefix=$out";
  buildPhase = "${python.executable} waf";
  installPhase = "${python.executable} waf install";
}
