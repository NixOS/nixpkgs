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
  version = "2.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromBitbucket {
    owner = "mustang51";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IBrd4PH8EzVVVFQtJdJ8bTMLEzfh7MYMe79yuCrhmww=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
    urllib3
  ];

  doCheck = false; # tests fail and upstream does not seem to run them either

  nativeCheckInputs = [
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
