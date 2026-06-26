{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "asmog";
  version = "0.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-k8dC3g2oY/b4w4m7Y/HUy/6/3Tm1kntx9tjoyXqDaJE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Project doesn't ship the tests
  # https://github.com/kstaniek/python-ampio-smog-api/issues/2
  doCheck = false;

  pythonImportsCheck = [ "asmog" ];

  meta = {
    description = "Python module for Ampio Smog Sensors";
    homepage = "https://github.com/kstaniek/python-ampio-smog-api";
    license = with lib.licenses; asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
