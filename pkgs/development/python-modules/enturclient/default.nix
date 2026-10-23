{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "enturclient";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hfurubotten";
    repo = "enturclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-83ui1BYqiRr+IwaJeXNppMnOTQCF9uJD5Kus93CDsUA=";
  };

  pythonRelaxDeps = [ "async_timeout" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  pythonImportsCheck = [ "enturclient" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "tests/dto/" ];

  meta = {
    description = "Python library for interacting with the Entur.org API";
    homepage = "https://github.com/hfurubotten/enturclient";
    changelog = "https://github.com/hfurubotten/enturclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
