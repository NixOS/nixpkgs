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
  version = "0.20.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1b1ce1c0f1e3457489672bc3a4db375a06f61ae7797a9eedf71ea788cea3870";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ sphinx ];

  # this can be removed >0.19.0
  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools_scm < 4" "setuptools_scm"
  '';

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
    homepage = "https://github.com/jab/bidict";
    description = "Efficient, Pythonic bidirectional map data structures and related functionality";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
