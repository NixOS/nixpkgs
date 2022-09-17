{ lib
, aiosmtpd
, buildPythonPackage
, fetchPypi
, werkzeug
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3cR5q6lqfaDnocx9OjA+UFgtbVBYA+j2e4JyGPn+D2U=";
  };

  propagatedBuildInputs = [
    aiosmtpd
    werkzeug
  ];

  # all tests access network: does not work in sandbox
  doCheck = false;

  pythonImportsCheck = [
    "pytest_localserver"
  ];

  meta = with lib; {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = "https://github.com/pytest-dev/pytest-localserver";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
