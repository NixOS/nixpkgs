{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aio-wattwaechter";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SmartCircuits-GmbH";
    repo = "WattWaechter-PyPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1qtjw7QcEe/hrr55FrZqKLXj5tG5z5S62QrWdk54Yqs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_wattwaechter" ];

  meta = {
    description = "Async Python client for the WattWächter smart meter API";
    homepage = "https://github.com/SmartCircuits-GmbH/WattWaechter-PyPI";
    changelog = "https://github.com/SmartCircuits-GmbH/WattWaechter-PyPI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
