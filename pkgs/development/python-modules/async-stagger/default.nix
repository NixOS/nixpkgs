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
  version = "0.4.0.post1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "twisteroidambassador";
    repo = "async_stagger";
    rev = "refs/tags/v${version}";
    hash = "sha256-uJohc3EsAKevqT0J+N0Cqop3xy0PCM5jsP6YYtx+HuQ=";
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
