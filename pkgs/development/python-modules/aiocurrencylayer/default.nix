{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiocurrencylayer";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "aiocurrencylayer";
    tag = finalAttrs.version;
    hash = "sha256-l9M9ejcaXLkIFtD3Qz3dkTR4xDIZuT94OT4yg/6ipYA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiocurrencylayer" ];

  meta = {
    description = "Python API for interacting with currencylayer";
    homepage = "https://github.com/home-assistant-ecosystem/aiocurrencylayer";
    changelog = "https://github.com/home-assistant-ecosystem/aiocurrencylayer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
