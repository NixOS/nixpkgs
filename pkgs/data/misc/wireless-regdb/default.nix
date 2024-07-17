{
  lib,
  stdenvNoCC,
  fetchurl,
  directoryListingUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2024.07.04";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-mDKhThviSr/3vjDe48mhr7X9/PR1oNkar+8Dn42F9es=";
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
