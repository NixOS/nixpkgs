{ stdenv, fetchurl, xalanc, xercesc, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "xml-security-c";
  version = "2.0.2";

  src = fetchurl {
    url = "https://www.apache.org/dist/santuario/c-library/${pname}-${version}.tar.gz";
    sha256 = "1prh5sxzipkqglpsh53iblbr7rxi54wbijxdjiahzjmrijqa40y3";
  };

  configureFlags = [
    "--with-openssl"
    "--with-xerces"
    "--with-xalan"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ xalanc xercesc openssl ];

  meta = {
    homepage = http://santuario.apache.org/;
    description = "C++ Implementation of W3C security standards for XML";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
