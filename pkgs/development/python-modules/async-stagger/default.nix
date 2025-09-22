{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "async-stagger";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "twisteroidambassador";
    repo = "async_stagger";
    tag = "v${version}";
    hash = "sha256-qLeTP5FWHho/CbXth3OQNW15Y8uibOh35KqskoIUTHQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  disabledTests = [
    # "OSError: [Errno 0] fileno not supported" during teardown
    "test_create_connected_sock_normal"
  ];

  pythonImportsCheck = [ "async_stagger" ];

  meta = with lib; {
    description = "Happy Eyeballs connection algorithm and underlying scheduling logic in asyncio";
    homepage = "https://github.com/twisteroidambassador/async_stagger";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
