{
  lib,
  stdenvNoCC,
  fetchurl,
  directoryListingUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2024.10.07";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-928r15plPp+d1QVI2Z0DpKTrFX2gVt/ViS9APsKPs9U=";
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
