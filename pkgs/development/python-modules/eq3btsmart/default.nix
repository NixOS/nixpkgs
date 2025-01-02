{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bleak,
  construct-typing,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eq3btsmart";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "EuleMitKeule";
    repo = "eq3btsmart";
    rev = "refs/tags/${version}";
    hash = "sha256-30ULuK3uAb3Bc1AoCyol+TL/gcSh5hn7t+Ys7JA9faQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    construct-typing
  ];

  pythonImportsCheck = [ "eq3btsmart" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/EuleMitKeule/eq3btsmart/releases/tag/${version}";
    description = "Python library that allows interaction with eQ-3 Bluetooth smart thermostats";
    homepage = "https://github.com/EuleMitKeule/eq3btsmart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
