{ lib
, buildPythonPackage
, fetchPypi
, pytest-runner
, pytest
}:

buildPythonPackage rec {
  version = "2.1.1";
  pname = "PasteDeploy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6dead6ab9823a85d585ef27f878bc647f787edb9ca8da0716aa9f1261b464817";
  };

  buildInputs = [ pytest-runner ];

  checkInputs = [ pytest ];

  # no tests in PyPI tarball
  # should be included with versions > 2.0.1
  doCheck = false;

  meta = with lib; {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = "http://pythonpaste.org/deploy/";
    license = licenses.mit;
  };

}
