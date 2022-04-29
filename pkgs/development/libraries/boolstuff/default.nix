{ lib, stdenv, fetchurl, pkg-config }:
stdenv.mkDerivation rec {
  pname = "boolstuff";
  version = "0.1.16";

  src = fetchurl {
    url = "https://perso.b2b2c.ca/~sarrazip/dev/${pname}-${version}.tar.gz";
    sha256 = "10qynbyw723gz2vrvn4xk2var172kvhlz3l3l80qbdsfb3d12wn0";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Library for operations on boolean expression binary trees";
    homepage = "http://perso.b2b2c.ca/~sarrazip/dev/boolstuff.html";
    license = "GPL";
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.all;
  };
}
