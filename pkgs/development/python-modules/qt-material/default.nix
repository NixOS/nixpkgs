{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
}:

buildPythonPackage rec {
  pname = "qt-material";
  version = "2.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tdu1relyF8964za7fAR8kL6zncfyBIpJjJFq1fL3riM=";
  };

  propagatedBuildInputs = [ jinja2 ];

  pythonImportsCheck = [ "qt_material" ];

  meta = {
    description = "Material inspired stylesheet for PySide2, PySide6, PyQt5 and PyQt6";
    homepage = "https://github.com/UN-GCPDS/qt-material";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ _999eagle ];
  };
}
