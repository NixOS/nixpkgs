{ lib
, bluepy
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = version;
    sha256 = "sha256-8u5KeWVaCOksag2CYE7GBl36crB4k9YdLZ5aHD9hlwU=";
  };

  propagatedBuildInputs = [ bluepy ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "switchbot" ];

  meta = with lib; {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
