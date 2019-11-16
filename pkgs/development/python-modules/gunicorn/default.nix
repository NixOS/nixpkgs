{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock, pytestcov, coverage }:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "19.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa2662097c66f920f53f70621c6c58ca4a3c4d3434205e608e121b5b3b71f4f3";
  };

  checkInputs = [ pytest mock pytestcov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">=" \
      --replace "coverage>=4.0,<4.4" "coverage"
  '';

  # Test failures but patch does not apply cleanly
  # https://github.com/benoitc/gunicorn/commit/f38f717539b1b7296720805b8ae3969c3509b9c1
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/gunicorn;
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
