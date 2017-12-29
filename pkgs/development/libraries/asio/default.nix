{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.10.8";

  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "0jgdl4fxw0hwy768rl3lhdc0czz7ak7czf3dg10j21pdpfpfvpi6";
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
