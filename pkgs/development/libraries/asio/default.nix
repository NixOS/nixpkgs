{stdenv, fetchurl, boost, openssl}:

stdenv.mkDerivation rec {
  name = "asio-1.10.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/asio/${name}.tar.bz2";
    sha256 = "1lqxm3gc8rzzjq0m843l59ggbw32bih7smm5spry1j5khfc86p41";
  };

  propagatedBuildInputs = [ boost ];
  buildInputs = [ openssl ];

  meta = {
    homepage = http://asio.sourceforge.net/;
    description = "Cross-platform C++ library for network and low-level I/O programming";
    license = "boost";
  };

}
