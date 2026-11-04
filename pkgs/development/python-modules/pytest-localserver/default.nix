{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchPypi,
  werkzeug,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-localserver";
  version = "0.10.0.post0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_localserver";
    inherit (finalAttrs) version;
    hash = "sha256-BsIaZmCdhitCvZy4FjNIIOaW6o93ys3f4VkSfUhkmFE=";
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
    changelog = "https://github.com/pytest-dev/pytest-localserver/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
})
