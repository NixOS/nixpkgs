{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hypothesis
, pytestcache
, pytest
, glibcLocales
, mock ? null
, pathlib ? null
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "5.4.1";

  checkInputs = [
    hypothesis
    pytestcache
    pytest
    glibcLocales
  ]
  # pathlib was made part of standard library in 3.5:
  ++ (lib.optionals (pythonOlder "3.4") [ pathlib ])
  # based on testing-requirements.txt:
  ++ (lib.optionals (pythonOlder "3.3") [ mock ]);

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae73b005135dc152e7b282b2d4cf19380d8cab4c4026461ee9f37bf3aa12e344";
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
