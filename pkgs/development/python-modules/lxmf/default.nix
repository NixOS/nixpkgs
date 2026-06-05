{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rns,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxmf";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = finalAttrs.version;
    hash = "sha256-Lx7eG7idbqjJrOE15/OJ8kh++4STQHxNVMTRVXdAEYE=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "rns" ];

  dependencies = [ rns ];

  pythonImportsCheck = [ "LXMF" ];

  nativeCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${finalAttrs.src.tag}";
    # Reticulum License
    # https://github.com/markqvist/LXMF/blob/master/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lxmd";
  };
})
