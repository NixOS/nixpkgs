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
  version = "0.17.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1icj0fnfx47n6i33pj5gfrmd1rzpvah1jihhdhqiqx2cy9rs6x4c";
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
