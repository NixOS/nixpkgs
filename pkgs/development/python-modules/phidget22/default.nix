{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  libphidget22,
  libphidget22extra,
}:
let
  pname = "phidget22";
  version = "1.25.20260408";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lGazwh+9H34SfclZlR5sThLxrfnSDPsaCH4cVQ1JuTk=";
  };

  build-system = [ setuptools ];

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
