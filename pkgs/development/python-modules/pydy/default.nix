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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e/Ssfd5llioA7ccLULlRdHR113IbR4AJ4/HmzQuU7vI=";
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
