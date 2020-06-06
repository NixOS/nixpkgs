{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, entrypoints, functools32, typing
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c69ac1668e434d37a2d2880b3ca9aafd54b3a10a3ac1ab101d22f29e29cf8634";
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
    homepage = "https://pypi.python.org/pypi/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
