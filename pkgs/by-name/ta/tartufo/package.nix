{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tartufo";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "godaddy";
    repo = "tartufo";
    tag = "v${version}";
    hash = "sha256-s7gqGvOnie7lGlpW3wfd8igWfowxwg9mftRjiHnvedc=";
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
    changelog = "https://github.com/godaddy/tartufo/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tartufo";
  };
}
