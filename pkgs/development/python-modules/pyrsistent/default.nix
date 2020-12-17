{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, six
, pytest_4
, hypothesis_4
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.17.3";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e";
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
