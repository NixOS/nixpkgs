{ stdenv, buildPythonPackage, fetchPypi, isPy27
, coverage
, mock
, pytest
, pytestcov
, setuptools
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "20.0.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1904bb2b8a43658807108d59c3f3d56c2b6121a701161de0ddf9ad140073c626";
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
    homepage = "https://github.com/benoitc/gunicorn";
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
