{ lib
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "pure-python-adb-homeassistant";
  version = "0.1.7.dev0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xXXEp8oYGcJLTfoBDUSZrIHSgDvB2EHbVMHoG4Hk+t8=";
  };

  # Disable tests as they require docker, docker-compose and a dedicated
  # android emulator
  doCheck = false;

  pythonImportsCheck = [ "adb_messenger" ];

  meta = with lib; {
    description = "Python implementation of the ADB client";
    homepage = "https://github.com/JeffLIrion/pure-python-adb";
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };
}
