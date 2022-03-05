{ lib
, bluepy
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.13.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = version;
    hash = "sha256-Zgpnw4It3yyy9RQqt5SxeJXl1Z3J3Rp9baLfiw5Bgow=";
  };

  propagatedBuildInputs = [
    bluepy
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
