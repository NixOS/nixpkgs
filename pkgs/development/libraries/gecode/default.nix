{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "4.3.0";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "18a1nd6sxqqh05hd9zwcgq9qhqrr6hi0nbzpwpay1flkv5gvg2d7";
  };

  buildInputs = [ perl ];
}
