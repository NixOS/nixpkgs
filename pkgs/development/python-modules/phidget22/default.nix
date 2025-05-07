{
  lib,
  buildPythonPackage,
  fetchPypi,

  libphidget22,
  libphidget22extra,
}:
let
  pname = "phidget22";
  version = "1.22.20250422";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jzmpcjq5swkxlmdjg3b413jfi1jdw208qld3r98akr7z7rxnc6k";
  };

  propagatedBuildInputs = [
    libphidget22
    libphidget22extra
  ];

  pythonImportsCheck = [ "Phidget22" ];

  meta = {
    homepage = "https://www.phidgets.com/docs/Language_-_Python";
    changelog = "https://phidgets.com/?view=changelog";
    description = "Lightweight python bindings to the native C library for Phidget devices";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bohreromir ];
  };
}
