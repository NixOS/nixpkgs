{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "monocypher";
  version = "3.1.3";

  src = fetchurl {
    url = "https://monocypher.org/download/monocypher-${version}.tar.gz";
    hash = "sha256-tEK1d98o+MNsqgHZrpARtd2ccX2UvlIBaKBONtf1AW4=";
  };

  patches = [
    # Fix cross-compilation
    (fetchpatch {
      url = "https://github.com/LoupVaillant/Monocypher/commit/376715e1c0ebb375e50dfa757bc89486c9a7b404.patch";
      hash = "sha256-tuwSUaU4w+jkaj10ChMgUmOQmoKYnv5JgJ1og8EXxFk=";
    })
  ];

  makeFlags = [ "AR:=$(AR)" "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = with lib; {
    description = "Boring crypto that simply works";
    homepage = "https://monocypher.org";
    license = with licenses; [ bsd2 cc0 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sikmir ];
  };
}
