{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywaze";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "pywaze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yhECJORKVM8R/+CjhSTwgtCPeQ8QwIuG3EZHmtjVkX0=";
  };

  build-system = [ hatchling ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "pywaze" ];

  meta = {
    description = "Module for calculating WAZE routes and travel times";
    homepage = "https://github.com/eifinger/pywaze";
    changelog = "https://github.com/eifinger/pywaze/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
