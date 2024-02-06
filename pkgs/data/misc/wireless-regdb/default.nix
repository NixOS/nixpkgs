{ lib, stdenvNoCC, fetchurl, directoryListingUpdater, crda }:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2023.09.01";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-JtTCpyfMWSObhHNarYVrfH0LBOMKpcI1xPf0f18FNJE=";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  passthru = {
    tests = {
      inherit crda; # validate data base signature
    };
    updateScript = directoryListingUpdater { };
  };

  meta = with lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = "http://wireless.kernel.org/en/developers/Regulatory/";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
