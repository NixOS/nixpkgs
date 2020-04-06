{ lib
, buildPythonPackage
, python
, fetchPypi
, pytest
, cython
, numpy
, scipy
, matplotlib
, networkx
, nibabel
}:

buildPythonPackage rec {
  pname = "nitime";
  version = "0.8.1";
  disabled = python.pythonVersion != "3.7";  # gcc error when running Cython with Python 3.8

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hb3x5196z2zaawb8s7lhja0vd3n983ncaynqfl9qg315x9ax7i6";
  };

  checkInputs = [ pytest ];
  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy matplotlib networkx nibabel ];

  checkPhase = "pytest nitime/tests";

  meta = with lib; {
    homepage = https://nipy.org/nitime;
    description = "Algorithms and containers for time-series analysis in time and spectral domains";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
