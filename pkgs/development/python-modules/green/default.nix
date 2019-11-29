{ lib, buildPythonPackage, fetchPypi, isPy3k
, colorama
, coverage
, termstyle
, lxml
, unidecode
, mock
, backports_shutil_get_terminal_size
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17cfgq0s02p5cjrsvcicqxiq6kflahjsd9pm03f054x7lpvqi5cv";
  };

  propagatedBuildInputs = [
    colorama coverage termstyle unidecode lxml
  ] ++ lib.optionals (!isPy3k) [ mock backports_shutil_get_terminal_size ];

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
