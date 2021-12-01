{ lib, stdenv, fetchurl, xalanc, xercesc, openssl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "xml-security-c";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://apache/santuario/c-library/${pname}-${version}.tar.gz";
    sha256 = "1prh5sxzipkqglpsh53iblbr7rxi54wbijxdjiahzjmrijqa40y3";
  };

  configureFlags = [
    "--with-openssl"
    "--with-xerces"
    "--with-xalan"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xalanc xercesc openssl ];

  meta = {
    homepage = "http://santuario.apache.org/";
    description = "C++ Implementation of W3C security standards for XML";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jagajaga ];
  };
}
