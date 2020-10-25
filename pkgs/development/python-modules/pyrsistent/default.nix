{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest_4
, hypothesis_4
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa2ae1c2e496f4d6777f869ea5de7166a8ccb9c2e06ebcf6c7ff1b670c98c5ef";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest_4 hypothesis_4 ];

  postPatch = ''
    substituteInPlace setup.py --replace 'pytest<5' 'pytest'
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tobgu/pyrsistent/";
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };

}
