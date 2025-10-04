{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bleak,
  bleak-retry-connector,
  construct-typing,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "eq3btsmart";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EuleMitKeule";
    repo = "eq3btsmart";
    tag = version;
    hash = "sha256-9x2uQUpLl0bSOiEBTvt6IPZCJ3Oj+U4knlvrTXPGs3I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
    construct-typing
  ];

  pythonImportsCheck = [ "eq3btsmart" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/EuleMitKeule/eq3btsmart/releases/tag/${src.tag}";
    description = "Python library that allows interaction with eQ-3 Bluetooth smart thermostats";
    homepage = "https://github.com/EuleMitKeule/eq3btsmart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
