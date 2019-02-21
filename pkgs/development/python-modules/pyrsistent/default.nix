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
  version = "0.14.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07f7ae71291af8b0dbad8c2ab630d8223e4a8c4e10fc37badda158c02e753acf";
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
