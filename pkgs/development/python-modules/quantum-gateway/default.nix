{
  lib,
  buildPythonPackage,
  esprima,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  urllib3,
}:

buildPythonPackage rec {
  pname = "quantum-gateway";
  version = "0.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cisasteelersfan";
    repo = "quantum_gateway";
    rev = version;
    hash = "sha256-jwLfth+UaisPR0p+UHfm6qMXT2eSYWnsYEp0BqyeI9U=";
  };

  propagatedBuildInputs = [
    urllib3
    esprima
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "quantum_gateway" ];

  disabledTests = [
    # Tests require network features
    "TestGateway3100"
  ];

  meta = with lib; {
    description = "Python library for interacting with Verizon Fios Quantum gateway devices";
    homepage = "https://github.com/cisasteelersfan/quantum_gateway";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
