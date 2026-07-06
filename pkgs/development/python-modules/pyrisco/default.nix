{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrisco";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pyrisco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-moFKikAIBLWfkpADjNKqZd3jAg5LPapubB1pGmx8OPo=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrisco" ];

  meta = {
    description = "Python interface to Risco alarm systems through Risco Cloud";
    homepage = "https://github.com/OnFreund/pyrisco";
    changelog = "https://github.com/OnFreund/pyrisco/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
