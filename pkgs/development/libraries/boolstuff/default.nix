{ lib, stdenv, fetchurl, pkg-config }:
stdenv.mkDerivation rec {
  pname = "boolstuff";
  version = "0.1.17";

  src = fetchurl {
    url = "http://perso.b2b2c.ca/~sarrazip/dev/${pname}-${version}.tar.gz";
    hash = "sha256-WPFUoTUofigPxTRo6vUbVTEVWMeEPDWszCA05toOX0I=";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Library for operations on boolean expression binary trees";
    homepage = "http://perso.b2b2c.ca/~sarrazip/dev/boolstuff.html";
    license = "GPL";
    maintainers = [ lib.maintainers.marcweber ];
    mainProgram = "booldnf";
    platforms = lib.platforms.all;
  };
}
