{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  orjson,
  pint,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiocomelit";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EB07sAGSyTpsCNH8xwOuHBYhQyajBnZBP+8WCLBq7i4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    colorlog
    orjson
    pint
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiocomelit" ];

  meta = {
    description = "Library to control Comelit Simplehome";
    homepage = "https://github.com/chemelli74/aiocomelit";
    changelog = "https://github.com/chemelli74/aiocomelit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
