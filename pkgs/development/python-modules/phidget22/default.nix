{
  lib,
  buildPythonPackage,
  fetchPypi,

  libphidget22,
  libphidget22extra,
}:
let
  pname = "phidget22";
  version = "1.22.20250714";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-55d8O21m37kAwZ4+2GC4tb5fmSiAg8z2mRJn0Jg1Adk=";
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
