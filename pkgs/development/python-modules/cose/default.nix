{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Python deps
  attrs,
  cbor2,
  certvalidator,
  cryptography,
  ecdsa,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cose";
  version = "1.0.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TimothyClaeys";
    repo = "pycose";
    rev = "v${version}";
    hash = "sha256-8d6HebWlSKgx7dmOnT7ZZ5mrMfg6mNWhz1hHPv75XF4=";
  };

  propagatedBuildInputs = [
    attrs
    cbor2
    certvalidator
    cryptography
    ecdsa
    setuptools
  ];

  pythonImportsCheck = [ "pycose" ];

  meta = {
    description = "Python implementation of the COSE specification";
    homepage = "https://github.com/TimothyClaeys/pycose";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ t4ccer ];
  };
}
