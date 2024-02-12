{ lib
, buildPythonPackage
, fetchFromGitHub

# build system
, setuptools

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asn1crypto";
  version = "1.5.1";
  pyproject = true;

  # Pulling from Github to run tests
  src = fetchFromGitHub {
    owner = "wbond";
    repo = "asn1crypto";
    rev = version;
    hash = "sha256-M8vASxhaJPgkiTrAckxz7gk/QHkrFlNz7fFbnLEBT+M=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
    license = lib.licenses.mit;
    homepage = "https://github.com/wbond/asn1crypto";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
