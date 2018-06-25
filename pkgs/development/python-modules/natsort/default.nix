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
  version = "5.3.2";

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
    sha256 = "94056276c41be501d9fad3ade61d4eb4edf3b37fea53829b3294b75dc1d23708";
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
