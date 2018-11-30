{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wireless-regdb-${version}";
  version = "2018.10.24";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/${name}.tar.xz";
    sha256 = "05lixkdzy7f3wpan6svh1n9f70rs0kfw6hl6p34sl8bxqxd88ghd";
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
