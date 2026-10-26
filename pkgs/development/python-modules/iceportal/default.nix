{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iceportal";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-iceportal";
    tag = finalAttrs.version;
    hash = "sha256-kpAUgGi2fAHzQYuZAaQW9wdrYjwbduRsoTwSuzcjJa8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iceportal" ];

  meta = {
    description = "Library for getting data from the ICE Portal";
    homepage = "https://github.com/home-assistant-ecosystem/python-iceportal";
    changelog = "https://github.com/home-assistant-ecosystem/python-iceportal/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
