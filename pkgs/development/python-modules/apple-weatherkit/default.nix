{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  aiohttp-retry,
  pyjwt,
}:

buildPythonPackage (finalAttrs: {
  pname = "apple-weatherkit";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "python-weatherkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6dln/599XTJrIY2wL8n9WdHEjJ75goYeZC5szQ6WNsk=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiohttp-retry
    pyjwt
  ]
  ++ pyjwt.optional-dependencies.crypto;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "apple_weatherkit" ];

  meta = {
    description = "Python library for Apple WeatherKit";
    homepage = "https://github.com/tjhorner/python-weatherkit";
    changelog = "https://github.com/tjhorner/python-weatherkit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
