{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "tre";
  version = "0.8.0";
  src = fetchurl {
    url = "https://laurikari.net/tre/${pname}-${version}.tar.gz";
    sha256 = "1pd7qsa7vc3ybdc6h2gr4pm9inypjysf92kab945gg4qa6jp11my";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/t/tre/0.8.0-6/debian/patches/03-cve-2016-8859";
      sha256 = "0navhizym6qxd4gngrsslbij8x9r3s67p1jzzhvsnq6ky49j7w3p";
    })
  ];

  meta = {
    description = "Lightweight and robust POSIX compliant regexp matching library";
    homepage = "https://laurikari.net/tre/";
    license = lib.licenses.bsd2;
    mainProgram = "agrep";
    platforms = lib.platforms.unix;
  };
}
