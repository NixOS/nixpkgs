{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymiele";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3GNjfRenX3fNGk1GVv9wMzZr7z+OhEGYmvJebQ0WsJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "pymiele" ];

  meta = {
    changelog = "https://github.com/astrandb/pymiele/releases/tag/v${finalAttrs.version}";
    description = "Lib for Miele integration with Home Assistant";
    homepage = "https://github.com/astrandb/pymiele";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
