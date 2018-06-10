{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "flake8";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7253265f7abd8b313e3892944044a365e3f4ac3fcdcfb4298f55ee9ddf188ba0";
  };

  buildInputs = [ pytest mock pytestrunner ];
  propagatedBuildInputs = [ pyflakes pycodestyle mccabe ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ]
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ configparser ];

  meta = with stdenv.lib; {
    description = "Code checking using pep8 and pyflakes";
    homepage = https://pypi.python.org/pypi/flake8;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
