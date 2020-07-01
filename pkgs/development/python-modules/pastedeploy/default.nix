{ stdenv
, buildPythonPackage
, fetchPypi
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "PasteDeploy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7559878b6e92023041484be9bcb6d767cf4492fc3de7257a5dae76a7cc11a9b";
  };

  buildInputs = [ pytestrunner ];

  checkInputs = [ pytest ];

  # no tests in PyPI tarball
  # should be included with versions > 2.0.1
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = "http://pythonpaste.org/deploy/";
    license = licenses.mit;
  };

}
