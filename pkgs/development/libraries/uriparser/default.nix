{ stdenv, fetchurl, cpptest, pkgconfig, doxygen, graphviz }:

stdenv.mkDerivation rec {
  name = "uriparser-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/uriparser/Sources/${version}/${name}.tar.bz2";
    sha256 = "08vvcmg4mcpi2gyrq043c9mfcy3mbrw6lhp86698hx392fjcsz6f";
  };


  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cpptest doxygen graphviz ];

  # There is actually no .map files to install in doc for v0.8.4
  # (dot outputs only SVG and PNG in this release)
  preBuild = ''
    substituteInPlace doc/Makefile.am --replace " html/*.map" ""
    substituteInPlace doc/Makefile.in --replace " html/*.map" ""
  '';


  meta = with stdenv.lib; {
    homepage = http://uriparser.sourceforge.net/;
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu ];
  };
}
