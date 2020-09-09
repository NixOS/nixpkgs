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
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5a90e247237ac7e320120961608cf65191134fa400d327cbd4d09864c880935";
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
