{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prek,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "rf-protocols";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "rf-protocols";
    tag = finalAttrs.version;
    hash = "sha256-kO53S3MCYD6MUpRwhgP8cD2S0j38WKR6Bik5CXSaq3w=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    prek
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rf_protocols" ];

  meta = {
    description = "Library to decode and encode radio frequency signals";
    homepage = "https://github.com/home-assistant-libs/rf-protocols";
    changelog = "https://github.com/home-assistant-libs/rf-protocols/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
