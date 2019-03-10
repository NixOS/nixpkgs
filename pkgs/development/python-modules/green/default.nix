{ lib, buildPythonPackage, fetchPypi, isPy3k, colorama, coverage, termstyle, unidecode, mock, backports_shutil_get_terminal_size }:

buildPythonPackage rec {
  pname = "green";
  version = "2.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea6e2699a2e58df834d2c845fb2b076c12d4835daecfcb658c6bd5583ebf4b7d";
  };

  propagatedBuildInputs = [
    colorama coverage termstyle unidecode
  ] ++ lib.optionals (!isPy3k) [ mock backports_shutil_get_terminal_size ];

  meta = with lib; {
    description = "Python test runner";
    homepage = https://github.com/CleanCut/green;
    license = licenses.mit;
  };
}
