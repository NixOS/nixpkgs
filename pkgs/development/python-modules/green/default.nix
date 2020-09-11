{ lib, buildPythonPackage, fetchPypi, isPy3k
, colorama
, coverage
, termstyle
, lxml
, unidecode
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17cfgq0s02p5cjrsvcicqxiq6kflahjsd9pm03f054x7lpvqi5cv";
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
    homepage = https://github.com/CleanCut/green;
    license = licenses.mit;
  };
}
