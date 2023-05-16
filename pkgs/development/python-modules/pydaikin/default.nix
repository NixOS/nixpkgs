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
<<<<<<< HEAD
  version = "2.11.1";
=======
  version = "2.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromBitbucket {
    owner = "mustang51";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IBrd4PH8EzVVVFQtJdJ8bTMLEzfh7MYMe79yuCrhmww=";
=======
    hash = "sha256-cJkrBt4HRH2SX4YWo+gK4rd7uyZRzLUvFXJ6L5nxzeM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
    urllib3
  ];

<<<<<<< HEAD
  doCheck = false; # tests fail and upstream does not seem to run them either

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
