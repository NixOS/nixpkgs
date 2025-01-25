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

  meta = with lib; {
    description = "User-friendly view of FreeRTOS kernel objects in GDB";
    homepage = "https://github.com/espressif/freertos-gdb";
    license = licenses.asl20;
    maintainers = with maintainers; [
      danc86
    ];
  };
}
