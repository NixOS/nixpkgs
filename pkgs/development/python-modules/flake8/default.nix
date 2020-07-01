{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, functools32, typing, importlib-metadata
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f04b9fcbac03b0a3e58c0ab3a0ecc462e023a9faf046d57794184028123aa208";
  };

  checkInputs = [ pytest mock pytestrunner ];
  propagatedBuildInputs = [ pyflakes pycodestyle mccabe ]
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ configparser functools32 ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ]
    ++ stdenv.lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Code checking using pep8 and pyflakes";
    homepage = "https://pypi.python.org/pypi/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
