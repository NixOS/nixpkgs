{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, jsonpickle
, paho-mqtt
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyduke-energy";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjmeli";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qHVQ7ehvhVM2IL8DcoB6TU2Q4GBn4Ewmzs6Yp46r6xE=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonpickle
    paho-mqtt
    python-dateutil
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyduke_energy"
  ];

  meta = with lib; {
    description = "Python module for the Duke Energy API";
    homepage = "https://github.com/mjmeli/pyduke-energy";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
