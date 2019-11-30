{ stdenv, fetchurl, cmake, libdigidoc, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkgconfig, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.14.1";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     sha256 = "0yrcfw5i1jddz7x3j9zzlcwjlzdbi10wns7kbblbp03nx7vk2vqy";
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
