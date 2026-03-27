{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "tartufo";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "godaddy";
    repo = "tartufo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GWxDGsoWVKjg/2zTPx+xsMmrBp6yAC5pq5/AALmY7No=";
  };

  pythonRelaxDeps = [
    "cached-property"
    "tomlkit"
  ];

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
    changelog = "https://github.com/godaddy/tartufo/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tartufo";
  };
})
