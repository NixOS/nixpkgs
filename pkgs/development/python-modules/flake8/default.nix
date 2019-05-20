{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, fetchpatch
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, entrypoints, functools32, typing
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "859996073f341f2670741b51ec1e67a01da142831aa1fdc6242dbf88dffbe661";
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
