{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "0.23.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = https://github.com/wbond/asn1crypto;
  };
}