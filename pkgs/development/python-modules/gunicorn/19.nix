{ stdenv, buildPythonPackage, fetchPypi
, coverage
, mock
, pytest
, pytestcov
, setuptools
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "19.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1080jk1ly8j0rc6lv8i33sj94rxjaskd1732cdq5chdqb3ij9ppr";
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
