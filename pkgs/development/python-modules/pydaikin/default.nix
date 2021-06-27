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
  version = "2.4.3";
  disabled = pythonOlder "3.6";

  src = fetchFromBitbucket {
    owner = "mustang51";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i013ma2fs6an3izak6zbs9lbr4l7b5x54d0xagw6gqf5n8dsclq";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
    urllib3
  ];

  # while they have tests, they do not run them in their CI and they fail as of 2.4.3
  # AttributeError: 'DaikinBRP069' object has no attribute 'last_hour_cool_energy_consumption'
  doCheck = false;

  checkInputs = [
    freezegun
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydaikin" ];

  meta = with lib; {
    description = "Python Daikin HVAC appliances interface";
    homepage = "https://bitbucket.org/mustang51/pydaikin";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
