{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "3.7.3";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "e7cc8bcc18b49195fef0544061bdd2e484a1240923e4e85fa39e8d6bb492854c";
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
