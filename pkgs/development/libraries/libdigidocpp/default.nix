{ lib, stdenv, fetchurl, fetchpatch, cmake, minizip, pcsclite, opensc, openssl
, xercesc, xml-security-c, pkg-config, xsd, zlib, xalanc, xxd }:

stdenv.mkDerivation rec {
  version = "3.16.0";
  pname = "libdigidocpp";

  src = fetchurl {
     url = "https://github.com/open-eid/libdigidocpp/releases/download/v${version}/libdigidocpp-${version}.tar.gz";
     hash = "sha256-XgObeVQJ2X7hNIelGK55RTtkKvU6D+RkLMc24/PZCzY=";
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
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.jagajaga ];
  };
}
