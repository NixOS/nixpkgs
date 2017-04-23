{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock, pytestcov, coverage }:

buildPythonPackage rec {
  pname = "gunicorn";
  name = "${pname}-${version}";
  version = "19.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08mnl5l1p47q5wk38d7mafnhsqk50yba0l9kvc2vwrx61jgidqgf";
  };

  buildInputs = [ pytest mock pytestcov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">="
  '';

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/gunicorn;
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
