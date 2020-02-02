{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bf4xxaig0b9dv6njynaqk2j7vlpagh3y49s9qj95y0jvjw5q8as";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = https://github.com/wbond/asn1crypto;
  };
}