{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "ucl-1.03";
  src = fetchurl {
    url = "https://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz";
    sha256 = "b865299ffd45d73412293369c9754b07637680e5c826915f097577cd27350348";
  };

  # needed to successfully compile with gcc 6
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=c90";

  meta = {
    homepage = "http://www.oberhumer.com/opensource/ucl/";
    description = "Portable lossless data compression library";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
