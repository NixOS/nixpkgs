{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
, hypothesis
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.14.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xwaqjjn665wd1rllqzndmlc8yzfw2wxakpfwlh6ir6kgbajff2s";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest hypothesis ];

  # pytestrunner is only needed to run tests
  patches = [ ./no-setup-requires-pytestrunner.patch ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tobgu/pyrsistent/;
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };

}
