{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, sphinx
, hypothesis
, py
, pytest
, pytest-benchmark
, sortedcollections
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d10630fd5d86b7c165387473c5180e7fca7635f12e24b1f426aac259c72c81a";
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
