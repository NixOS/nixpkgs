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
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "gardena-bluetooth";
    rev = "refs/tags/${version}";
    hash = "sha256-H2v96G/mu17puq8jNyk6L9iuWUvRombPd+s6byNQ4Zw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    bleak-retry-connector
    tzlocal
  ];

  passthru.optional-dependencies = {
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
