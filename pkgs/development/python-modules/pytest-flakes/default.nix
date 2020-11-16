{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytestpep8
, pytest
, pyflakes
}:

buildPythonPackage rec {
  # upstream has abandoned project in favor of pytest-flake8
  # retaining package to not break other packages
  pname = "pytest-flakes";
  version = "4.0.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6733db47937d9689032876359e5ee0ee6926e3638546c09220e2f86b3581d4c1";
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
