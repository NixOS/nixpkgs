{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysnmpcrypto";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysnmpcrypto";
    rev = "refs/tags/v${version}";
    hash = "sha256-gNRD8mSWVVLXwJjb3nT7IKnjTdwTutFDnQybgZTY2b0=";
  };

  build-system = [ poetry-core ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysnmpcrypto" ];

  meta = with lib; {
    description = "Strong crypto support for Python SNMP library";
    homepage = "https://github.com/lextudio/pysnmpcrypto";
    changelog = "https://github.com/lextudio/pysnmpcrypto/blob/v${version}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
