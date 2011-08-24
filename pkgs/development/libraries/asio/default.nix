{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.5.3";
  
  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "08fdsv1zhwbfwlx3r3dzl1371lxy5gw92ms0kqcscxqn0ycf3rlj";
  };

  propagatedBuildInputs = [ boost ];
  buildInputs = [ openssl ];

  meta = {
    homepage = http://asio.sourceforge.net/;
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = "boost";
  };

}
