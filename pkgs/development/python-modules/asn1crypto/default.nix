{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "1.4.0";

  src = fetchFromGitHub {
     owner = "wbond";
     repo = "asn1crypto";
     rev = "1.4.0";
     sha256 = "19abibn6jw20mzi1ln4n9jjvpdka8ygm4m439hplyrdfqbvgm01r";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = "https://github.com/wbond/asn1crypto";
  };
}
