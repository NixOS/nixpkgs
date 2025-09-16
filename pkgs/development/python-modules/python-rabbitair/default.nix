{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "python-rabbitair";
  version = "0.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rabbit-air";
    repo = "python-rabbitair";
    rev = "v${version}";
    hash = "sha256-CGr7NvnGRNTiKq5BpB/zmfgyd/2ggTbO0nj+Q+MavTs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    zeroconf
  ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rabbitair" ];

  disabledTests = [
    # Tests require network access
    "test_info"
    "test_no_response"
    "test_protocol_error"
    "test_sequential_requests"
    "test_set_state"
    "test_state_a2"
    "test_state_a3"
    "test_zeroconf"
  ];

  meta = with lib; {
    description = "Module for the control of Rabbit Air air purifiers";
    homepage = "https://github.com/rabbit-air/python-rabbitair";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
