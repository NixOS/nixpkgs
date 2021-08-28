{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2021.04.21";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-nkwCsqlxDfTb2zJ8OWEujLuuZJWYev7drrqyjB6j2Po=";
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
