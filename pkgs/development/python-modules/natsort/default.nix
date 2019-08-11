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
  version = "6.0.0";

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
    sha256 = "ff3effb5618232866de8d26e5af4081a4daa9bb0dfed49ac65170e28e45f2776";
  };

  # testing based on project's tox.ini
  checkPhase = ''
    pytest --doctest-modules natsort
    pytest
  '';

  meta = {
    description = "Natural sorting for python";
    homepage = https://github.com/SethMMorton/natsort;
    license = lib.licenses.mit;
  };
}
