{ stdenv, buildPythonPackage, fetchPypi
, coverage
, mock
, pytest
, pytestcov
, setuptools
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "19.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa2662097c66f920f53f70621c6c58ca4a3c4d3434205e608e121b5b3b71f4f3";
  };

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytest mock pytestcov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">=" \
      --replace "coverage>=4.0,<4.4" "coverage"
  '';

  # better than no tests
  checkPhase = ''
    $out/bin/gunicorn --help > /dev/null
  '';

  pythonImportsCheck = [ "gunicorn" ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/gunicorn;
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
