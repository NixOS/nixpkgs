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
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EuleMitKeule";
    repo = "eq3btsmart";
    tag = version;
    hash = "sha256-iT3XojEvD2FH+2/ybZ8xOkh7DE1FlFdRLu3tml3HA4A=";
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
