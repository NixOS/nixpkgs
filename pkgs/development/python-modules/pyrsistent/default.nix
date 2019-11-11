{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest_4
, hypothesis
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.15.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb6545dbeb1aa69ab1fb4809bfbf5a8705e44d92ef8fc7c2361682a47c46c778";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest_4 hypothesis ];

  postPatch = ''
    substituteInPlace setup.py --replace 'pytest<5' 'pytest'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tobgu/pyrsistent/;
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };

}
