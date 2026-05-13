{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rns,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxmf";
  version = "0.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = finalAttrs.version;
    hash = "sha256-Q84v1CkyEYpW4QdtOD6zp7bn4UzMDeS9Q8fO91BnuPA=";
  };

  build-system = [ setuptools ];

  dependencies = [ rns ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "LXMF" ];

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
