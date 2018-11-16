{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "0.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = https://github.com/wbond/asn1crypto;
  };
}