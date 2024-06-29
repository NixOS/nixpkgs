{ lib, pkg-config, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "freertos-gdb";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o0ZoTy7OLVnrhSepya+MwaILgJSojs2hfmI86D9C3cs=";
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
