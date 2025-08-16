{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
}:

buildPythonPackage rec {
  pname = "qt-material";
  version = "2.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tQCgwfXvj0aozwN9GqW9+epOthgYC2MyU5373QZHrQ0=";
  };

  propagatedBuildInputs = [ jinja2 ];

  pythonImportsCheck = [ "qt_material" ];

  meta = with lib; {
    description = "Material inspired stylesheet for PySide2, PySide6, PyQt5 and PyQt6";
    homepage = "https://github.com/UN-GCPDS/qt-material";
    license = licenses.bsd2;
    maintainers = with maintainers; [ _999eagle ];
  };
}
