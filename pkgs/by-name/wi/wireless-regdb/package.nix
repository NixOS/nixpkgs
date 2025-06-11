{
  lib,
  stdenvNoCC,
  fetchurl,
  directoryListingUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2025.02.20";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-V/jnchz1qIDBOuDCAu27IQkqBg1F+enFm80qgnK/pFY=";
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
