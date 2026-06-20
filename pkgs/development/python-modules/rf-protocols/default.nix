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
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "rf-protocols";
    tag = finalAttrs.version;
    hash = "sha256-F0pvEg+Cns3czK/yI6M0hpgRpk67jUgRKqgzCBYmgUY=";
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
