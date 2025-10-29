{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  rns,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = version;
    hash = "sha256-5sY6Sf4oRwSXQR0YAfqeSmW1aASTT2iZLd5+BFx+5Mw=";
  };

  build-system = [ setuptools ];

  dependencies = [ rns ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "LXMF" ];

  meta = {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${src.tag}";
    # Reticulum License
    # https://github.com/markqvist/LXMF/blob/master/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lxmd";
  };
}
