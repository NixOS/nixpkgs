{ lib, python, buildPythonPackage, fetchPypi, numpy, treelog, stringly, coverage }:

buildPythonPackage rec {
  pname = "nutils";
  version = "7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sw310l2yb8wbcv2qhik8s928zjh2syzz2qxisglbzski9qdw2x6";
  };

  pythonImportChecks = [ "nutils" ];

  propagatedBuildInputs = [
    numpy
    treelog
    stringly
  ];

  checkInputs = [ coverage ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    description = "Numerical Utilities for Finite Element Analysis";
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
