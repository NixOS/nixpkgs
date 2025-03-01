{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  cryptography,
  pycryptodomex,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysnmpcrypto";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysnmpcrypto";
    tag = "v${version}";
    hash = "sha256-gNRD8mSWVVLXwJjb3nT7IKnjTdwTutFDnQybgZTY2b0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
    pycryptodomex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysnmpcrypto" ];

  meta = with lib; {
    description = "Strong crypto support for Python SNMP library";
    homepage = "https://github.com/lextudio/pysnmpcrypto";
    changelog = "https://github.com/lextudio/pysnmpcrypto/blob/${version}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
