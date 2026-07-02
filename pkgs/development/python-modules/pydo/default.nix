{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  azure-core,
  azure-identity,
  isodate,
  msrest,

  # tests
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
  responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydo";
  version = "0.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "pydo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ykGrZN5Q4qcFLSHdOoiR4zOW1iTk8/laxcItcX7pJug=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    azure-core
    azure-identity
    isodate
    msrest
  ];

  pythonImportsCheck = [ "pydo" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    responses
  ];

  # integration tests require hitting the live api with a
  # digital ocean token
  disabledTestPaths = [
    "tests/integration/"
  ];

  meta = {
    description = "Official DigitalOcean Client based on the DO OpenAPIv3 specification";
    homepage = "https://github.com/digitalocean/pydo";
    changelog = "https://github.com/digitalocean/pydo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
