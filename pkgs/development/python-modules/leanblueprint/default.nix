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
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "leanblueprint";
    owner = "PatrickMassot";
    rev = "v0.0.20";
    hash = "sha256-jCNIf0pTO/7M4aLrbFyjGcTPmaIQnw32itKJdyCMn+g=";
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
