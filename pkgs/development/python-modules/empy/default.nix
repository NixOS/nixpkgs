{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "empy";
  version = "4.2";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hvFeHal0Pnmi6bLLrPGhPQt/sYNbYlTrJTyXi3Iof08=";
  };
  pythonImportsCheck = [ "em" ];
  meta = with lib; {
    homepage = "http://www.alcyone.com/software/empy/";
    description = "Templating system for Python";
    mainProgram = "em.py";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.lgpl21Only;
  };
}
