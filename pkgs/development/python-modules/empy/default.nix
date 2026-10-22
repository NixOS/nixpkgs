{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "empy";
  version = "4.2.1";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uDHWQvypVQeCC1N3TAUYAxQrhEG4xCv4AAEdoGukJBs=";
  };
  pythonImportsCheck = [ "em" ];
  meta = {
    homepage = "http://www.alcyone.com/software/empy/";
    description = "Templating system for Python";
    mainProgram = "em.py";
    maintainers = with lib.maintainers; [ nkalupahana ];
    license = lib.licenses.bsd3;
  };
}
