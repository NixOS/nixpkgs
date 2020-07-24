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
  version = "3.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65f87e4c0d2aca63eb32b01c78233e6f920a58ebabc4f85dd9d8f1c6a92a5184";
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
    homepage = "https://github.com/CleanCut/green";
    license = licenses.mit;
  };
}
