{stdenv, fetchurl, cmake, zlib}:

stdenv.mkDerivation rec {
  name = "libproxy-0.4.11";
  src = fetchurl {
    url = "http://libproxy.googlecode.com/files/${name}.tar.gz";
    sha256 = "0jw6454gxjykmbnbh544axi8hzz9gmm4jz1y5gw1hdqnakg36gyw";
  };
  buildInputs = [cmake zlib];
}
