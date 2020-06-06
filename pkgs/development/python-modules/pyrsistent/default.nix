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
  version = "0.15.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdc7b5e3ed77bed61270a47d35434a30617b9becdf2478af76ad2c6ade307280";
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
