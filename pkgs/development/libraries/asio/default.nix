{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.12.0";

  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "1bfk746kcs3cmvfvxjp3w9y6zpybjj8s002jjd3snrp2syd0nd9c";
  };

  propagatedBuildInputs = [ boost ];
  buildInputs = [ openssl ];

  meta = {
    homepage = http://asio.sourceforge.net/;
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = stdenv.lib.licenses.boost;
    platforms = stdenv.lib.platforms.unix;
  };

}
