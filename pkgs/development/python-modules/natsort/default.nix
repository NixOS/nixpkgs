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
  version = "7.0.1";

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
    sha256 = "a633464dc3a22b305df0f27abcb3e83515898aa1fd0ed2f9726c3571a27258cf";
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
