{ stdenv, fetchurl, cpptest, pkgconfig }:

stdenv.mkDerivation rec {
  name = "uriparser-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/uriparser/Sources/${version}/${name}.tar.bz2";
    sha256 = "08vvcmg4mcpi2gyrq043c9mfcy3mbrw6lhp86698hx392fjcsz6f";
  };
  
  configureFlags = "--disable-doc";
  
  buildInputs = [ cpptest pkgconfig ];
  
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
