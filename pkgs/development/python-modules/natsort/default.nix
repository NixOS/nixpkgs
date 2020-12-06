{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytest
, pytestcov
, pytest-mock
, hypothesis
, glibcLocales
, pathlib ? null
, isPy3k
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "7.1.0";

  checkInputs = [
    pytest
    pytestcov
    pytest-mock
    hypothesis
    glibcLocales
  ]
  # pathlib was made part of standard library in 3.5:
  ++ (lib.optionals (pythonOlder "3.4") [ pathlib ]);

  src = fetchPypi {
    inherit pname version;
    sha256 = "33f3f1003e2af4b4df20908fe62aa029999d136b966463746942efbfc821add3";
  };

  # Does not support Python 2
  disabled = !isPy3k;

  # testing based on project's tox.ini
  # natsort_keygen has pytest mock issues
  checkPhase = ''
    pytest --doctest-modules natsort
    pytest --ignore=tests/test_natsort_keygen.py
  '';

  meta = {
    description = "Natural sorting for python";
    homepage = "https://github.com/SethMMorton/natsort";
    license = lib.licenses.mit;
  };
}
