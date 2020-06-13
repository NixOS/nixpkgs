{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, functools32, typing, importlib-metadata
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02527892hh0qjivxaiphzalj7q32qkna1cqaikjs7c03mk5ryjzh";
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
