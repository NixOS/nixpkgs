{ lib
, bluepy
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = version;
    sha256 = "sha256-YqXR6zL8rM2p6YqK8BX82F9HZHgfpfEU4qBiVSud0hw=";
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
