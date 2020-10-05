{ lib, buildPythonPackage, fetchPypi, isPy3k
, colorama
, coverage
, termstyle
, lxml
, unidecode
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.2.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7cc909290019903323481a1819addefb9d32b4868773326dec4648c63bbc071";
  };

  propagatedBuildInputs = [
    colorama coverage termstyle unidecode lxml
  ];

  # let green run it's own test suite
  checkPhase = ''
    $out/bin/green green
  '';

  meta = with lib; {
    description = "Python test runner";
    homepage = "https://github.com/CleanCut/green";
    license = licenses.mit;
  };
}
