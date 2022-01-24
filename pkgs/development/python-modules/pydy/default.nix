{ lib
, buildPythonPackage
, fetchPypi
, nose
, cython
, numpy
, scipy
, sympy
}:

buildPythonPackage rec {
  pname = "pydy";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b487a62b55a8c8664009b09bf789254b2c942cd704a380bedb1057418c94fa2";
  };

  checkInputs = [
    nose
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    sympy
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
