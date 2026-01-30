{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  azure-core,
  azure-identity,
  isodate,
  msrest,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "pydo";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "pydo";
    tag = "v${version}";
    hash = "sha256-NqQ3xFZd+ELOMinn7GBvYA1ov9Ff4s+qvom5l7ZV81k=";
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
    changelog = "https://github.com/digitalocean/pydo/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
