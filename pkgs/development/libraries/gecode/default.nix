{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "5.0.0";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "0yz7m4msp7g2jzsn216q74d9n7rv6qh8abcv0jdc1n7y2nhjzzzl";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = http://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ maintainers.manveru ];
  };
}
