{ stdenv, fetchurl, m4, bison, flex, openssl, zlib }:

let version = "2.7.15"; in

stdenv.mkDerivation {
  name = "gsoap-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gsoap2/files/gSOAP/2.7.15%20stable/gsoap_${version}.tar.gz";
    sha256 = "3ed883ab1a3d32b5bb2bf599306f247f6de3ffedd8890eb0e6303ae15995dc12";
  };

  buildInputs = [ m4 bison flex openssl zlib ];
  meta = {
    homepage = "http://www.cs.fsu.edu/~engelen/soap.html";
    description = "The gSOAP toolkit is an open source C and C++ software development toolkit for SOAP/WSDL and XML Web services.";
    license = "free-non-copyleft";
  };
}
