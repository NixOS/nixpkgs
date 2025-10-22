{
  buildPythonPackage,
  colorama,
  decorator,
  dunamai,
  fetchFromGitHub,
  funcy,
  git,
  hatchling,
  hatch-vcs,
  iteration-utilities,
  jinja2,
  jinja2-ansible-filters,
  lib,
  mkdocs-material,
  mkdocs-mermaid2-plugin,
  nix-update-script,
  mkdocstrings,
  packaging,
  pathspec,
  plumbum,
  pydantic,
  pygments,
  pyyaml,
  pyyaml-include,
  questionary,
}:

buildPythonPackage rec {
  pname = "copier";
  version = "9.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "copier-org";
    repo = "copier";
    tag = "v${version}";
    # Conflict on APFS on darwin
    postFetch = ''
      rm $out/tests/demo/doc/ma*ana.txt
    '';
    hash = "sha256-ZBRJ4FrdhtKr273D2amwA3dJhISZAORqFqoh//963Fg=";
  };

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    colorama
    decorator
    dunamai
    funcy
    iteration-utilities
    jinja2
    jinja2-ansible-filters
    mkdocs-material
    mkdocs-mermaid2-plugin
    mkdocstrings
    packaging
    pathspec
    plumbum
    pydantic
    pygments
    pyyaml
    pyyaml-include
    questionary
  ];

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ git ]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library and command-line utility for rendering projects templates";
    homepage = "https://copier.readthedocs.io";
    changelog = "https://github.com/copier-org/copier/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
    mainProgram = "copier";
  };
}
