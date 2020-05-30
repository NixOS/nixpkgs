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
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "6.2.1";

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
    sha256 = "c5944ffd2343141fa5679b17991c398e15105f3b35bb11beefe66c67e08289d5";
  };

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
