{ lib, buildPythonPackage, fetchPypi, isPy3k, colorama, coverage, termstyle, unidecode, mock, backports_shutil_get_terminal_size }:

buildPythonPackage rec {
  pname = "green";
  version = "2.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c0c163bd2ce2da1f201eb69fd92fc24aaeab884f9e5c5a8c23d507a53336fa8";
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
