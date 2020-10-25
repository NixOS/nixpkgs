{ lib, buildPythonPackage, fetchPypi, isPy3k
, colorama
, coverage
, termstyle
, lxml
, unidecode
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.2.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fc2fdd86dbc700ca6afa6d83f1216bb9bcaf4d1b3ae36ba52878ac1b9cd063c";
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
