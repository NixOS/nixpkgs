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
  version = "2.4.2";
  disabled = pythonOlder "3.6";

  src = fetchFromBitbucket {
    owner = "mustang51";
    repo = pname;
    rev = "v${version}";
    sha256 = "13cslszjhd1x7j0ja0n0wpy62hb2sdmkrmjl3qhwqfggps2w2wy1";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
    urllib3
  ];

  # while they have tests, they do not run them in their CI and they fail as of 2.4.2
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
