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
  version = "0.15.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3b280d030afb652f79d67c5586157c5c1355c9a58dfc7940566e28d28f3df1b";
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
