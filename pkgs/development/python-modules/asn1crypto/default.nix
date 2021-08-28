{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4f6e119474e58e04a2b1af817eb585b4fd72bdd89b998624712b5c99be7641c";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = "https://github.com/wbond/asn1crypto";
  };
}
