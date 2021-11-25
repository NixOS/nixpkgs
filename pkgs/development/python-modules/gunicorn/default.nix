{ lib, buildPythonPackage, fetchPypi, isPy27
, coverage
, mock
, pytest
, pytest-cov
, setuptools
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "20.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0a968b5ba15f8a328fdfd7ab1fcb5af4470c28aaf7e55df02a99bc13138e6e8";
  };

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytest mock pytest-cov coverage ];

  prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">=" \
      --replace "coverage>=4.0,<4.4" "coverage"
  '';

  # better than no tests
  checkPhase = ''
    $out/bin/gunicorn --help > /dev/null
  '';

  pythonImportsCheck = [ "gunicorn" ];

  meta = with lib; {
    homepage = "https://github.com/benoitc/gunicorn";
    description = "WSGI HTTP Server for UNIX";
    license = licenses.mit;
  };
}
