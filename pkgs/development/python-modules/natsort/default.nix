{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hypothesis
, pytestcache
, pytestflakes
, pytestpep8
, pytest
, glibcLocales
, mock ? null
, pathlib ? null
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "5.2.0";

  checkInputs = [
    hypothesis
    pytestcache
    pytestflakes
    pytestpep8
    pytest
    glibcLocales
  ]
  # pathlib was made part of standard library in 3.5:
  ++ (lib.optionals (pythonOlder "3.4") [ pathlib ])
  # based on testing-requirements.txt:
  ++ (lib.optionals (pythonOlder "3.3") [ mock ]);

  src = fetchPypi {
    inherit pname version;
    sha256 = "c960082d2145b04723041c4b85092546560538e29664dd197a1344d5b090bc91";
  };

  # testing based on project's tox.ini
  checkPhase = ''
    pytest --doctest-modules natsort
    pytest --flakes --pep8
  '';

  meta = {
    description = "Natural sorting for python";
    homepage = https://github.com/SethMMorton/natsort;
    license = lib.licenses.mit;
  };
}
