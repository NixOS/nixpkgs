{ lib, buildPythonPackage, fetchPypi, isPy3k, colorama, coverage, termstyle, unidecode, mock, backports_shutil_get_terminal_size }:

buildPythonPackage rec {
  pname = "green";
  version = "2.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe937dab641e7bb8b7b0a3678bc1372f1759282934767b035de681a40da7033b";
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
