{ lib
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "pure-python-adb-homeassistant";
  version = "0.1.6.dev0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe6d90220a6880649f6d6df4e707ce5034676710ee6146145ef995f7b769a482";
  };

  # Disable tests as they require docker, docker-compose and a dedicated
  # android emulator
  doCheck = false;

  meta = with lib; {
    description = "Pure python implementation of the adb client";
    homepage = https://github.com/JeffLIrion/pure-python-adb;
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };
}
