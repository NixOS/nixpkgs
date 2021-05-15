{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libmowgli";
  version = "2.1.3";

  src = fetchurl {
    url = "https://github.com/atheme/libmowgli-2/archive/v${version}.tar.gz";
    sha256 = "0xx4vndmwz40pxa5gikl8z8cskpdl9a30i2i5fjncqzlp4pspymp";
  };

  meta = with lib; {
    description = "A development framework for C providing high performance and highly flexible algorithms";
    homepage = "https://github.com/atheme/libmowgli-2";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
