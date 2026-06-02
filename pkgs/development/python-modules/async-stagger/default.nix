{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "async-stagger";
  version = "0.4.1";
  pyproject = true;

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

  meta = {
    description = "Happy Eyeballs connection algorithm and underlying scheduling logic in asyncio";
    homepage = "https://github.com/twisteroidambassador/async_stagger";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
