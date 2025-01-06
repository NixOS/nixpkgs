{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "freertos-gdb";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5rkB01OdbD5Z4vA6dbqhWp5pGwqI1IlE4IE1dSdT1QE=";
  };

  # Project has no tests
  doCheck = false;

  meta = {
    description = "User-friendly view of FreeRTOS kernel objects in GDB";
    homepage = "https://github.com/espressif/freertos-gdb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      danc86
    ];
  };
}
