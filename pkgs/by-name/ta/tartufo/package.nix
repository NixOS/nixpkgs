{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tartufo";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "godaddy";
    repo = "tartufo";
    rev = "refs/tags/v${version}";
    hash = "sha256-mwwenmSCxnzD2DLf1a/dsQjwJ2GetMgRGj/noqWJ/E0=";
  };

  pythonRelaxDeps = [ "tomlkit" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    cached-property
    click
    colorama
    gitpython
    pygit2
    tomlkit
  ];

  pythonImportsCheck = [ "tartufo" ];

  meta = {
    description = "Tool to search through git repositories for high entropy strings and secrets";
    homepage = "https://github.com/godaddy/tartufo";
    changelog = "https://github.com/godaddy/tartufo/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tartufo";
  };
}
