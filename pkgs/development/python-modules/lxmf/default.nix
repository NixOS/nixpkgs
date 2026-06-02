{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rns,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxmf";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = finalAttrs.version;
    hash = "sha256-ohbZSpjIyCiiwXUjvr0UBXKN4OScdTzxx5QimPWnCAI=";
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
