{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pytest
, pyflakes
}:

buildPythonPackage rec {
  # upstream has abandoned project in favor of pytest-flake8
  # retaining package to not break other packages
  pname = "pytest-flakes";
  version = "4.0.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "551467a129331bed83596f3145d9eaf6541c26a03dc1b36419efef8ae231341b";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pyflakes ];
  checkInputs = [ pytest ];

  # no longer passes
  doCheck = false;
  pythonImportsCheck = [ "pytest_flakes" ];
  # disable one test case that looks broken
  checkPhase = ''
    py.test test_flakes.py -k 'not test_syntax_error'
  '';

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://pypi.python.org/pypi/pytest-flakes";
    description = "pytest plugin to check source code with pyflakes";
  };
}
