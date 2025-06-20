{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  callPackage,

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
buildPythonPackage rec {
  pname = "leanblueprint";
  version = "0.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "leanblueprint";
    owner = "PatrickMassot";
    tag = "v${version}";
    hash = "sha256-kikeLc0huJHe4Fq207U8sdRrH26bzpo+IVKjsLnrWgY=";
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

  passthru.tests.simple-blueprint = callPackage ./tests/simple-blueprint.nix { };

  meta = {
    description = "A plasTeX plugin allowing to write blueprints for Lean 4 projects";
    homepage = "https://github.com/PatrickMassot/leanblueprint";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
}
