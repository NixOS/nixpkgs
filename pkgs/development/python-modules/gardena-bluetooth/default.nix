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
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "gardena-bluetooth";
    tag = version;
    hash = "sha256-L726A0o9TIxFjHOxx0e42RIj4XMOdeZTJE2gWo6OhG4=";
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
