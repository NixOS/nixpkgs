{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
  async-timeout,
  aioresponses,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "foobot-async";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "foobot_async";
    inherit version;
    hash = "sha256-QQjysk2m8QkOpLBdC8kfuoA9PcljgEwzKyrIAhxHB4c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [ "foobot_async" ];

  meta = with lib; {
    description = "API Client for Foobot Air Quality Monitoring devices";
    homepage = "https://github.com/reefab/foobot_async";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
