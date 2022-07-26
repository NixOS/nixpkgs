{ lib
, bleak
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = "refs/tags/${version}";
    hash = "sha256-x1uRUr9mU510X2rSGBYBheB9rqsGBFr3SLnWcXiIBfk=";
  };

  propagatedBuildInputs = [
    bleak
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "switchbot"
  ];

  meta = with lib; {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
