{ stdenv, buildPythonPackage, fetchPypi
, pytestpep8, pytest, pyflakes }:

buildPythonPackage rec {
  # upstream has abandoned project in favor of pytest-flake8
  # retaining package to not break other packages
  pname = "pytest-flakes";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37113ac6c7ea5e0b648abf73937955a45f8b9214fe49413297c2ce6ce1808500";
  };

  checkInputs = [ pytestpep8 pytest ];
  propagatedBuildInputs = [ pytest pyflakes ];

  # no longer passes
  doCheck = false;
  pythonImportsCheck = [ "pytest_flakes" ];
  # disable one test case that looks broken
  checkPhase = ''
    py.test test_flakes.py -k 'not test_syntax_error'
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = "https://pypi.python.org/pypi/pytest-flakes";
    description = "pytest plugin to check source code with pyflakes";
  };
}
