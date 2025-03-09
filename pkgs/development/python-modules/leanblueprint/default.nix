{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  plasTeX,
  plastexshowmore,
  plastexdepgraph,
  click,
  rich,
  rich-click,
  tomlkit,
  jinja2,
  gitpython,
}:
buildPythonPackage {
  pname = "leanblueprint";
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "leanblueprint";
    owner = "PatrickMassot";
    rev = "v0.0.10";
    hash = "sha256-CUYdxEXgTf2vKDiOoeW4RV6tQ6prFhA4qMc0olZtZBM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    plasTeX
    plastexshowmore
    plastexdepgraph
    click
    rich
    rich-click
    tomlkit
    jinja2
    gitpython
  ];

  pythonImportsCheck = [ "leanblueprint" ];

  meta = {
    description = "This plasTeX plugin allowing to write blueprints for Lean 4 projects";
    homepage = "https://github.com/PatrickMassot/leanblueprint";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
}
