{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87620880a477123e01177a1f73d0f327210b43a3cdbd714efcd2fa49a8d7b384";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = https://github.com/wbond/asn1crypto;
  };
}