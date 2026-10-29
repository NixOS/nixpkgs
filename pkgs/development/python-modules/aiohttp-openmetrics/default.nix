{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  prometheus-client,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohttp-openmetrics";
  version = "0.0.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/ZRngcMlroCVTvIl+30DR4SI8LsSnTovuzg3YduWgWA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    prometheus-client
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "aiohttp_openmetrics" ];

  meta = {
    description = "OpenMetrics provider for aiohttp";
    homepage = "https://github.com/jelmer/aiohttp-openmetrics/";
    changelog = "https://github.com/jelmer/aiohttp-openmetrics/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
