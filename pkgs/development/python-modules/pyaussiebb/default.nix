{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pydantic,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyaussiebb";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yaleman";
    repo = "aussiebb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GD04Bq+uJs2JuTjtnGh6QKD4uFXwmGcOMB1Hu9yBlkI=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    aiohttp
    requests
    pydantic
  ];

  # Tests require credentials and requests-testing
  doCheck = false;

  pythonImportsCheck = [ "aussiebb" ];

  meta = {
    description = "Module for interacting with the Aussie Broadband APIs";
    homepage = "https://github.com/yaleman/aussiebb";
    changelog = "https://github.com/yaleman/pyaussiebb/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
