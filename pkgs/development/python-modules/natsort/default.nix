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
  version = "5.3.3";

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
    sha256 = "da930bfddce941526955dea8d35a44243c96adf919ceb758ba7bbd1ba5b0a39a";
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
