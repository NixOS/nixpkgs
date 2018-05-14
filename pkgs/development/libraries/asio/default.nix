{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.12.1";

  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "0nln45662kg799ykvqx5m9z9qcsmadmgg6r5najryls7x16in2d9";
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
