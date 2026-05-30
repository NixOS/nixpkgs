{
  lib,
  stdenvNoCC,
  fetchurl,
  directoryListingUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2026.03.18";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-${version}.tar.xz";
    hash = "sha256-X8AABHXYxTaMzFIignwWrvmLHramnJtaPnt+mFKJRaw=";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    description = "Wireless regulatory database for CRDA";
    homepage = "https://wireless.docs.kernel.org/en/latest/en/developers/regulatory/wireless-regdb.html";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
