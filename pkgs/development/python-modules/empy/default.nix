{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "empy";
  version = "4.1";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nXEul8E5WFm+E9K0V4jJGGzZfxwE2sUQOZEw8yhkM2c=";
  };
  pythonImportsCheck = [ "em" ];
  meta = with lib; {
    homepage = "http://www.alcyone.com/software/empy/";
    description = "A templating system for Python.";
    mainProgram = "em.py";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.lgpl21Only;
  };
}
