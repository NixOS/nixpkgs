{ stdenv, fetchurl, cmake, openssl }:

stdenv.mkDerivation rec {
  name = "minmay-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mazhe/minmay/archive/1.0.0.tar.gz";
    sha256 = "1amycxvhbd0lv6j5zsvxiwrx29jvndcy856j3b3bisys24h95zw2";
  };

  buildInputs = [ cmake openssl ];

  meta = {
    homepage = "https://github.com/mazhe/minmay";
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "An XMPP library (forked from the iksemel project)";
  };
}
