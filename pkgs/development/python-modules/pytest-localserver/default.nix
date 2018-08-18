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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a72af60a1ec8f73668a7884c86baf1fbe48394573cb4fa36709887217736c021";
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

