{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.10.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "16dxzkra0wmhm2vp2p9lb1h6qsdjk82sxfgj6zlz792n7jnms2l2";
  };

  propagatedBuildInputs = [ boost ];
  buildInputs = [ openssl ];

  meta = {
    homepage = http://asio.sourceforge.net/;
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = "boost";
  };

}
