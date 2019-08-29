{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2019.06.03";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1gslvh0aqdkv48jyr2ddq153mw28i7qz2ybrjj9qvkk3dgc7x4fd";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    description = "Wireless regulatory database for CRDA";
    homepage = http://wireless.kernel.org/en/developers/Regulatory/;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
