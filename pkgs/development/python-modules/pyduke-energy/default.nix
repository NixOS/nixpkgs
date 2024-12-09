{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  jsonpickle,
  paho-mqtt,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyduke-energy";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjmeli";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7KkUpsHg3P2cF0bVl3FzyAQwzeaCmg+vzRHlM/TIcNA=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonpickle
    paho-mqtt
    python-dateutil
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyduke_energy" ];

  meta = with lib; {
    description = "Python module for the Duke Energy API";
    homepage = "https://github.com/mjmeli/pyduke-energy";
    changelog = "https://github.com/mjmeli/pyduke-energy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
