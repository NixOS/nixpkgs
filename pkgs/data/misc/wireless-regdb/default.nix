{ lib, stdenvNoCC, fetchurl, directoryListingUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2024.05.08";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-mu4dhuvrs2O3FL7JQbKCDzHjt/Gkhd3J/L2ZhcfT58Q=";
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
