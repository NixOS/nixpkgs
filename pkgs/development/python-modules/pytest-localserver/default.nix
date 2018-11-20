{ buildPythonPackage
, lib
, fetchPypi
, requests
, pytest
, six
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0615b1698bdd2a1e6e396caf2f496020f4f69bccc0518df5050aeb02800f7c07";
  };

  propagatedBuildInputs = [ werkzeug ];
  buildInputs = [ pytest six requests ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = https://pypi.python.org/pypi/pytest-localserver;
    license = lib.licenses.mit;
  };
}

