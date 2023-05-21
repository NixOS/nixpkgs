{ lib
, buildPythonPackage
, fetchPypi
, numpy
, sympy
}:

buildPythonPackage rec {
  pname = "lbmpy";
  version = "1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-351AUGumRkHbLq1BSpU13lr4W3da4LxGabHX24TYqYw=";
  };

  # todo: requires pystencils, which has not been packed
  propagatedBuildInputs = [ numpy sympy ];

  pythonImportsCheck = [ "lbmpy" ];

  meta = with lib; {
    description = "Code Generation for Lattice Boltzmann Methods";
    homepage = "https://pypi.org/project/lbmpy/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
}
