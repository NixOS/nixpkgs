{ stdenv, fetchurl, cpptest, pkgconfig, doxygen, graphviz }:

stdenv.mkDerivation rec {
  name = "uriparser-0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/uriparser/Sources/0.8.2/${name}.tar.bz2";
    sha256 = "13sh7slys3y5gfscc40g2r3hkjjywjvxlcqr77ifjrazc6q6cvkd";
  };

  buildInputs = [ cpptest pkgconfig doxygen graphviz ];

  meta = with stdenv.lib; {
    homepage = http://uriparser.sourceforge.net/;
    description = "Strictly RFC 3986 compliant URI parsing library";
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.bsd3;
  };
}
