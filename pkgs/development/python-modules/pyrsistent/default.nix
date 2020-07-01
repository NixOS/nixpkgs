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
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28669905fe725965daa16184933676547c5bb40a5153055a8dee2a4bd7933ad3";
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
