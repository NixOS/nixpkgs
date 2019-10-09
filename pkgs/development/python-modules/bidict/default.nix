{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, sphinx
, hypothesis
, py
, pytest
, pytest-benchmark
, sortedcollections
, sortedcontainers
, isPy3k
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.18.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0br3ljvd56nqifr1mbwksvl5jjk40pihrrjlyn7hmc40yq6m5bvh";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ sphinx ];

  checkInputs = [
    hypothesis
    py
    pytest
    pytest-benchmark
    sortedcollections
    sortedcontainers
  ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = https://github.com/jab/bidict;
    description = "Efficient, Pythonic bidirectional map data structures and related functionality";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
