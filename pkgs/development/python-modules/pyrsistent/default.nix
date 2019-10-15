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
  version = "0.15.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cv5xvhfhlj88pb0ghdwivkfcmgi6503qjwxx4r6n06nd6hpzd1l";
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
