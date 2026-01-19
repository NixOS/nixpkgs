{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodomex,
  pysocks,
  pynacl,
  requests,
  six,
  varint,
  pytestCheckHook,
  pytest-cov-stub,
  responses,
}:

buildPythonPackage rec {
  pname = "monero";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "monero-ecosystem";
    repo = "monero-python";
    rev = "v${version}";
    hash = "sha256-WIF3pFBOLgozYTrQHLzIRgSlT3dTZTe+7sF/dVjVdTo=";
  };

  pythonRelaxDeps = [ "pynacl" ];
  pythonRemoveDeps = [ "ipaddress" ];

  pythonImportsCheck = [ "monero" ];

  propagatedBuildInputs = [
    pycryptodomex
    pynacl
    pysocks
    requests
    six
    varint
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    responses
  ];

  meta = {
    description = "Comprehensive Python module for handling Monero";
    homepage = "https://github.com/monero-ecosystem/monero-python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
