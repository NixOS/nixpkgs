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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a5427909d1dfda10772c1bae4b9803679c0a8f04adb66c338ac607773bfefc2";
  };

  propagatedBuildInputs = [ werkzeug ];
  checkInputs = [ pytest six requests ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = https://pypi.python.org/pypi/pytest-localserver;
    license = lib.licenses.mit;
  };
}

