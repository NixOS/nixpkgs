{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build-system
  setuptools,

  # dependencies
  packaging,
  requests,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "ixnetwork-restpy";
  version = "1.11.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "ixnetwork_restpy";
    inherit (finalAttrs) version;
    hash = "sha256-Ag8RGuWUr/hbQ5S/IpHhWivTuhd8L5eYAuAS8lOhesI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    requests
    setuptools
    websocket-client
  ];

  pythonImportsCheck = [
    "ixnetwork_restpy"
    "uhd_restpy"
  ];

  # The test suite requires a live IxNetwork chassis/session.
  doCheck = false;

  meta = {
    changelog = "https://github.com/OpenIxia/ixnetwork_restpy/blob/-/RELEASENOTES.md";
    description = "IxNetwork Python client library (RestPy)";
    homepage = "https://github.com/OpenIxia/ixnetwork_restpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
