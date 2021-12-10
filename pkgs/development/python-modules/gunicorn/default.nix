{ lib, buildPythonPackage, fetchFromGitHub, isPy27
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

  src = fetchFromGitHub {
     owner = "benoitc";
     repo = "gunicorn";
     rev = "20.1.0";
     sha256 = "1zhy6c69g8zyd76nlv9ipqrjicfz6f3pys2wgqjm0njhqfdlgly5";
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
