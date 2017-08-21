{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "flake8";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04izn1q1lgbr408l9b3vkxqmpi6mq47bxwc0iwypb02mrxns41xr";
  };

  buildInputs = [ pytest mock pytestrunner ];
  propagatedBuildInputs = [ pyflakes pycodestyle mccabe ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ]
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ configparser ];

  meta = with stdenv.lib; {
    description = "Code checking using pep8 and pyflakes";
    homepage = http://pypi.python.org/pypi/flake8;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
