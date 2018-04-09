{ lib, buildPythonPackage, fetchPypi, isPy3k, colorama, coverage, termstyle, unidecode, mock, backports_shutil_get_terminal_size }:

buildPythonPackage rec {
  pname = "green";
  version = "2.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cdd2934eff754c9664f373ee0d77cb1cb35dbbf3b719b8ae3b059718db875df";
  };

  prePatch = ''
    # See https://github.com/CleanCut/green/pull/182
    substituteInPlace setup.py --replace python-termstyle termstyle
  '';

  propagatedBuildInputs = [
    colorama coverage termstyle unidecode
  ] ++ lib.optionals (!isPy3k) [ mock backports_shutil_get_terminal_size ];

  meta = with lib; {
    description = "Python test runner";
    homepage = https://github.com/CleanCut/green;
    license = licenses.mit;
  };
}
