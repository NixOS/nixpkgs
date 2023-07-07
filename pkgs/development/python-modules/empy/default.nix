{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "empy";
  version = "3.3.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "c6xJeFtgFHnfTqGKfHm8EwSop8NMArlHLPEgauiPAbM=";
  };
  pythonImportsCheck = [ "em" ];
  meta = with lib; {
    homepage = "http://www.alcyone.com/software/empy/";
    description = "A templating system for Python.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.lgpl21Only;
  };
}
