{ lib, stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.2.0";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "sha256-ZpdtHgajUnVKI0Kvc9Guy7U8x82uK2jNoBO33c+SMjM=";
  };

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://mujs.com/";
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.isc;
  };
}
