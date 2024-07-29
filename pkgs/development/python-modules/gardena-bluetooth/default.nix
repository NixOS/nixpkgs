{
  lib,
  asyncclick,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "gardena-bluetooth";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "gardena-bluetooth";
    rev = "refs/tags/${version}";
    hash = "sha256-BV4chGkVp9H7gJQGKQZ0e4IiizMjCbDAU5MMf7hS9mE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    bleak-retry-connector
    tzlocal
  ];

  optional-dependencies = {
    cli = [ asyncclick ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "gardena_bluetooth" ];

  meta = with lib; {
    description = "Module for interacting with Gardena Bluetooth";
    homepage = "https://github.com/elupus/gardena-bluetooth";
    changelog = "https://github.com/elupus/gardena-bluetooth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
