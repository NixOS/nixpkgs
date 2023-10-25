{ lib
, aiosmtpd
, buildPythonPackage
, fetchPypi
, werkzeug
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-53tGVVy0OJMdIZxUvPn1lTwEB9ZFQ2pgK1cwur/T/js=";
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
    changelog = "https://github.com/pytest-dev/pytest-localserver/blob/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
