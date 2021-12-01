{ lib, stdenv, fetchurl, cmake, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkg-config, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.14.7";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     sha256 = "sha256-QdctW2+T8kPNUJv30pXZ/qfnw1Uhq6gScSjUI+bZMfY=";
  };

  nativeBuildInputs = [ cmake pkg-config xxd ];

  buildInputs = [
    minizip pcsclite opensc openssl xercesc
    xml-security-c xsd zlib xalanc
  ];

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
