{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "nrgkick-api";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andijakl";
    repo = "nrgkick-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZOVSQOjFPVnm3xnkhp+KFC9YbASEfzB05VpSzKcXJiU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nrgkick_api" ];

  meta = {
    description = "Python client for NRGkick Gen2 EV charger local REST API";
    homepage = "https://github.com/andijakl/nrgkick-api";
    changelog = "https://github.com/andijakl/nrgkick-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
