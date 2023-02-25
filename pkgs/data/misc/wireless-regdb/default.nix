{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2023.02.13";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-/oHoqGlNxHU6RQh6HEx+G0je5aWfX3ls43TqVQ8LLnM=";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = "http://wireless.kernel.org/en/developers/Regulatory/";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
