{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rns,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = version;
    hash = "sha256-bPRoKJGMy+JAyhKcRXKR3Jra5K1UAjRMg0lMt2lOvzA=";
  };

  build-system = [ setuptools ];

  dependencies = [ rns ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "LXMF" ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${src.tag}";
    # Reticulum License
    # https://github.com/markqvist/LXMF/blob/master/LICENSE
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
    mainProgram = "lxmd";
  };
}
