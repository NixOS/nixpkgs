{ lib
, aiohttp
, buildPythonPackage
, fetchFromBitbucket
, freezegun
, netifaces
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  pname = "pydaikin";
  version = "2.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromBitbucket {
    owner = "mustang51";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IONmzrCW/5nAEa7GlWMZsnweQWTSUwV4HwhXww6/9ig=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
    urllib3
  ];

  checkInputs = [
    freezegun
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydaikin"
  ];

  meta = with lib; {
    description = "Python Daikin HVAC appliances interface";
    homepage = "https://bitbucket.org/mustang51/pydaikin";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
