{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2018.05.31";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/${name}.tar.xz";
    sha256 = "0yxydxkmcb6iryrbazdk8lqqibig102kq323gw3p64vpjwxvrpz1";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=$(out)"
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
