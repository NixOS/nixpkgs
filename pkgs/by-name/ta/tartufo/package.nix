{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "tartufo";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "godaddy";
    repo = "tartufo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P+7BtqV4s+Z92PApuNYjTCjzAiKFUCx8sc1qkecEG4k=";
  };

  pythonRelaxDeps = [
    "cached-property"
    "gitpython"
    "pygit2"
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
