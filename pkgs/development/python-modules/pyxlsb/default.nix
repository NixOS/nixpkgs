{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyxlsb";
  version = "1.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gGLR6oYm0/GYDosc/pGkSDdHRJJC7LYQE7wt+FQ19oU=";
  };

  # package has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyxlsb" ];

  meta = with lib; {
    description = "Excel 2007-2010 Binary Workbook (xlsb) parser";
    homepage = "https://github.com/willtrnr/pyxlsb";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
