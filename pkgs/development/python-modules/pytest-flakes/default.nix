{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pytest
, pyflakes
}:

buildPythonPackage rec {
  # upstream has abandoned project in favor of pytest-flake8
  # retaining package to not break other packages
  pname = "pytest-flakes";
  version = "4.0.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf070c5485dad82d5b5f5d0eb08d269737e378492d9a68f5223b0a90924c7754";
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
