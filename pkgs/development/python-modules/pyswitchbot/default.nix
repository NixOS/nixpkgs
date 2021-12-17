{ lib
, bluepy
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = version;
    sha256 = "sha256-dx3OMzWJohOYCg7TnrqL4FLZoC+Q1dyJyUAdreDyfl0=";
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
