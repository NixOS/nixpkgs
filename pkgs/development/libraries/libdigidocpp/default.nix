{ lib, stdenv, fetchurl, fetchpatch, cmake, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkg-config, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.14.12";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     hash = "sha256-82AH18KcrkD7mHDy+2c9v7E3Kj7Cb7jCoLfmo09D8PU=";
  };

  nativeBuildInputs = [ cmake pkg-config xxd ];

  buildInputs = [
    minizip pcsclite opensc openssl xercesc
    xml-security-c xsd zlib xalanc
  ];

  outputs = [ "out" "lib" "dev" "bin" ];

  # libdigidocpp.so's `PKCS11Signer::PKCS11Signer()` dlopen()s "opensc-pkcs11.so"
  # itself, so add OpenSC to its DT_RUNPATH after the fixupPhase shrinked it.
  # https://github.com/open-eid/cmake/pull/35 might be an alternative.
  postFixup = ''
    patchelf --add-rpath ${opensc}/lib/pkcs11 $lib/lib/libdigidocpp.so
  '';

  meta = with lib; {
    description = "Library for creating DigiDoc signature files";
    homepage = "http://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
