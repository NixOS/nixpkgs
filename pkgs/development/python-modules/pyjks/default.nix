{
  buildPythonPackage,
  fetchPypi,
  lib,

  # pythonPackages
  pyasn1-modules,
  pycryptodomex,
  twofish,
}:

buildPythonPackage rec {
  pname = "pyjks";
  version = "20.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A3jOwV+xGy7Se6VNrZ/Zh9SOb2L0n8/xOPX3qLMSsEQ=";
  };

  propagatedBuildInputs = [
    pyasn1-modules
    pycryptodomex
    twofish
  ];

  # Tests assume network connectivity
  doCheck = false;

  meta = {
    description = "Pure-Python Java Keystore (JKS) library";
    homepage = "https://github.com/kurtbrose/pyjks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
