{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "newversion";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vemel";
    repo = "newversion";
    tag = finalAttrs.version;
    hash = "sha256-R26yZQnQN/+e8XD3YKl+3bJKGnZaVzOVoTlGHOyratg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "newversion" ];

  meta = {
    description = "PEP 440 version manager";
    homepage = "https://github.com/vemel/newversion";
    changelog = "https://github.com/vemel/newversion/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "newversion";
  };
})
