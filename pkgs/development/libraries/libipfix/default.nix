{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libipfix-${version}";
  version = "110209";
  src = fetchurl {
    url = "mirror://sourceforge/libipfix/files/libipfix/libipfix_110209.tgz";
    sha256 = "0h7v0sxjjdc41hl5vq2x0yhyn04bczl11bqm97825mivrvfymhn6";
  };
  meta = with stdenv.lib; {
    homepage = http://libipfix.sourceforge.net/;
    description = "The libipfix C-library implements the IPFIX protocol defined by the IP Flow Information Export working group of the IETF.";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lewo ];
  };
}
