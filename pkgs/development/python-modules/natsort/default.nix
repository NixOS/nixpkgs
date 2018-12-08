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
  version = "5.5.0";

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
    sha256 = "e29031f37aa264145d6ad9acdab335479ce3636806fc7aa70b7675a2b2198d09";
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
