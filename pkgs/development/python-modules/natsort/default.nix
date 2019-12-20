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
  version = "6.2.0";

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
    sha256 = "58c6fb2f355117e88a19808394ec1ed30a2ff881bdd2c81c436952caebd30668";
  };

  # testing based on project's tox.ini
  # natsort_keygen has pytest mock issues
  checkPhase = ''
    pytest --doctest-modules natsort
    pytest --ignore=tests/test_natsort_keygen.py
  '';

  meta = {
    description = "Natural sorting for python";
    homepage = https://github.com/SethMMorton/natsort;
    license = lib.licenses.mit;
  };
}
