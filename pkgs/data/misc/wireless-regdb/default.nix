{ lib, stdenvNoCC, fetchurl, directoryListingUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2024.01.23";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-yKYcms92+n60I56J9kDe4+hwmNn2m001GMnGD8bSDFU=";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = "http://wireless.kernel.org/en/developers/Regulatory/";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
