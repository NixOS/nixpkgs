{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchPypi,
  werkzeug,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_localserver";
    inherit version;
    hash = "sha256-JgcZfzkJEqslUl0SmsQ8PIdQSSVzaLP+CbXNA9zFJq8=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ werkzeug ];

  optional-dependencies = {
    smtp = [ aiosmtpd ];
  };

  # All tests access network: does not work in sandbox
  doCheck = false;

  pythonImportsCheck = [ "pytest_localserver" ];

  meta = {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = "https://github.com/pytest-dev/pytest-localserver";
    changelog = "https://github.com/pytest-dev/pytest-localserver/blob/v${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
}
