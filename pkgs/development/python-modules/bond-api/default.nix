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
  pname = "bond-api";
  version = "0.1.18";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prystupa";
    repo = "bond-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+87/j94eHyW3EMMBK+aXaNTVoNxsixeLusyBsPWa9yM=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bond_api" ];

  meta = {
    description = "Asynchronous Python wrapper library over Bond Local API";
    homepage = "https://github.com/prystupa/bond-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
