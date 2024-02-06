{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# tests
, pytestCheckHook
}:

buildPythonPackage {
  pname = "asn1crypto";
  version = "1.5.1-unstable-2023-11-03";
  pyproject = true;

  # Pulling from Github to run tests
  src = fetchFromGitHub {
    owner = "wbond";
    repo = "asn1crypto";
    # https://github.com/wbond/asn1crypto/issues/269
    rev = "b763a757bb2bef2ab63620611ddd8006d5e9e4a2";
    hash = "sha256-11WajEDtisiJsKQjZMSd5sDog3DuuBzf1PcgSY+uuXY=";
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
  };
}
