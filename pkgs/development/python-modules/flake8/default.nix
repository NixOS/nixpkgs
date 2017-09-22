{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "flake8";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c20044779ff848f67f89c56a0e4624c04298cd476e25253ac0c36f910a1a11d8";
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
