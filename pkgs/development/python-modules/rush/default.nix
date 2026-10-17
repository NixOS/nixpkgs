{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,

  # dependencies
  attrs,
}:

buildPythonPackage (finalAttrs: {

  pname = "rush";

  version = "2021.4.0";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gYYkB18DE/ZKTDi6YrxKZSbuMbRjmQyK6/A6mPWq8mQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    attrs
  ];

  meta = {
    changelog = "https://rush.readthedocs.io/en/latest/releases/${finalAttrs.version}.html";
    description = "Python libary for rate limiting";
    homepage = "https://rush.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eidoom ];
  };

})
