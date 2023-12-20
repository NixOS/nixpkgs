{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "empy";
  version = "4.0";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JNmmKyN+G1+c7Lqw6Ta/9zVAJS0R6sb95/62OxSHuOM=";
  };
  pythonImportsCheck = [ "em" ];
  meta = with lib; {
    homepage = "http://www.alcyone.com/software/empy/";
    description = "A templating system for Python.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.lgpl21Only;
  };
}
