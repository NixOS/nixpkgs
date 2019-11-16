{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, entrypoints, functools32, typing
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19241c1cbc971b9962473e4438a2ca19749a7dd002dd1a946eaba171b4114548";
  };

  checkInputs = [ pytest mock pytestrunner ];
  propagatedBuildInputs = [ entrypoints pyflakes pycodestyle mccabe ]
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ configparser functools32 ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Code checking using pep8 and pyflakes";
    homepage = https://pypi.python.org/pypi/flake8;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
