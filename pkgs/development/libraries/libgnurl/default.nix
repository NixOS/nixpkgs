{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "7.35.0";

  name = "libgnurl-${version}";

  src = fetchurl {
    url = "https://gnunet.org/sites/default/files/gnurl-${version}.tar.bz2";
    sha256 = "0dzj22f5z6ppjj1aq1bml64iwbzzcd8w1qy3bgpk6gnzqslsxknf";
  };

  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
  '';

  meta = with stdenv.lib; {
    description = "A fork of libcurl used by GNUnet";
    homepage    = https://gnunet.org/gnurl;
    maintainers = with maintainers; [ falsifian ];
    hydraPlatforms = platforms.linux;
  };
}
