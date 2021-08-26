{ lib, stdenv, fetchurl, cmake, libdigidoc, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkg-config, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.14.6";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     sha256 = "sha256-zDMxJyL/T3cXrqgMT15yZlCozgyOt5nNreottuuiGHk=";
  };

  nativeBuildInputs = [ cmake pkg-config xxd ];

  buildInputs = [
    libdigidoc minizip pcsclite opensc openssl xercesc
    xml-security-c xsd zlib xalanc
  ];

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
