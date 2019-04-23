{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, fetchpatch
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, entrypoints, functools32, typing
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d8c66a65635d46d54de59b027a1dda40abbe2275b3164b634835ac9c13fd048";
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
    maintainers = with maintainers; [ garbas ];
  };
}
