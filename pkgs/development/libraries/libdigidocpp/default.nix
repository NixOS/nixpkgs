{ stdenv, fetchurl, cmake, libdigidoc, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkgconfig, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.14.2";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     sha256 = "0d3p72gvnj00bxl6lzh6n5x1r37wj54mzzv700gngcvr3m62lkbv";
  };

  nativeBuildInputs = [ cmake pkgconfig xxd ];

  buildInputs = [
    libdigidoc minizip pcsclite opensc openssl xercesc
    xml-security-c xsd zlib xalanc
  ];

  meta = with stdenv.lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
