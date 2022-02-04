{ lib
, bluepy
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.13.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = version;
    sha256 = "0pdmssd5dr364p3lrkxqryjc0rbaw6xp724zwqf3i87qs6ljs928";
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
