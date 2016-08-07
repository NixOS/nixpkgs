{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.10.6";

  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "0phr6zq8z78dwhhzs3h27q32mcv1ffg2gyq880rw3xmilx01rmz0";
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
