{stdenv, fetchurl, boost, openssl
, version, sha256, ...
}:

with stdenv.lib;

stdenv.mkDerivation {
  name = "asio-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/asio/asio-${version}.tar.bz2";
    inherit sha256;
  };

  propagatedBuildInputs = [ boost ];

  buildInputs = [ openssl ];

  meta = {
    homepage = http://asio.sourceforge.net/;
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = licenses.boost;
    broken = stdenv.isDarwin;  # test when updating to >=1.12.1
    platforms = platforms.unix;
  };
}
