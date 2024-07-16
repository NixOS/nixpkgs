{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytest,
  pyflakes,
}:

buildPythonPackage rec {
  # upstream has abandoned project in favor of pytest-flake8
  # retaining package to not break other packages
  pname = "pytest-flakes";
  version = "4.0.5";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "953134e97215ae31f6879fbd7368c18d43f709dc2fab5b7777db2bb2bac3a924";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pyflakes ];
  nativeCheckInputs = [ pytest ];

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
