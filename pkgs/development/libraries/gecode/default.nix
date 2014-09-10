{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "4.3.0";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "18a1nd6sxqqh05hd9zwcgq9qhqrr6hi0nbzpwpay1flkv5gvg2d7";
  };

  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = http://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ maintainers.manveru ];
  };
}
