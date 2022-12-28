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
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjmeli";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-0fxFZQr8Oti17egBvpvE92YsIZ+Jf8gYRh0J2g5WTIc=";
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
