{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aioresponses,
  azure-core,
  azure-identity,
  isodate,
  msrest,
  responses,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pydo";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "pydo";
    tag = "v${version}";
    hash = "sha256-7DcsznR2XgFVFwgm6jAh13dG19YovFuTvicYkFGVEUg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aioresponses
    azure-core
    azure-identity
    isodate
    msrest
    responses
  ];

  pythonImportsCheck = [ "pydo" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
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
