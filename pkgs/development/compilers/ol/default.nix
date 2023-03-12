{ lib, stdenv, fetchFromGitHub, makeWrapper, unixtools }:

stdenv.mkDerivation rec {
  pname = "ol";
  version = "2.4";

  src = fetchFromGitHub {
    owner  = "yuriy-chumak";
    repo   = "ol";
    rev    = version;
    sha256 = "0fyxvip4nmih866s7x4v52226crjda7pw3mmva34nckg33a8gapv";
  };

  nativeBuildInputs = [ makeWrapper unixtools.xxd ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = with lib; {
    description = "Purely functional dialect of Lisp";
    homepage = "https://yuriy-chumak.github.io/ol/";
    longDescription = ''
      Otus Lisp (Ol in short) is a purely functional dialect of Lisp.

      It implements an extended subset of the R<sup>7</sup>RS Scheme
      ([PDF](https://small.r7rs.org/attachment/r7rs.pdf)), including
      but not limited to some SRFIs. It is tiny (~100KB), embeddable
      and cross-platform.  Provides a portable, high-level interface
      to call code written in another language.
    '';
    license = with licenses; [ lgpl3 mit ];
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ yuriy-chumak ];
  };
}
