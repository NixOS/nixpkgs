{
  lib,
  async-lru,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotools";
  version = "2.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "achimnol";
    repo = "aiotools";
    tag = finalAttrs.version;
    hash = "sha256-oBguMNOj3n9yq6La1WiZTZUmpDTu6zuVj87cQsX7Fk8=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    async-lru
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "aiotools" ];

  meta = {
    description = "Idiomatic asyncio utilities";
    homepage = "https://github.com/achimnol/aiotools";
    changelog = "https://github.com/achimnol/aiotools/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ robertjakub ];
  };
})
