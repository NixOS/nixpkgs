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
  format = "wheel";
in
buildPythonPackage {
  inherit pname version format;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    dist = "py3";
    sha256 = "sha256-qV7Jr1HPuvlp2fu/wgB8Qku1K/90fgzTY0uxbe/mFAk=";
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
