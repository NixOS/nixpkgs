{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytest
, pytest-cov
, pytest-mock
, hypothesis
, glibcLocales
, pathlib ? null
, isPy3k
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "7.1.1";

  checkInputs = [
    pytest
    pytest-cov
    pytest-mock
    hypothesis
    glibcLocales
  ]
  # pathlib was made part of standard library in 3.5:
  ++ (lib.optionals (pythonOlder "3.4") [ pathlib ]);

  src = fetchPypi {
    inherit pname version;
    sha256 = "00c603a42365830c4722a2eb7663a25919551217ec09a243d3399fa8dd4ac403";
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
