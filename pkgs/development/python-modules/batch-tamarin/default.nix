{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  typer,
  pydantic,
  psutil,
  tree-sitter,
  py-tree-sitter-spthy,
  diskcache,
  jinja2,
  graphviz,
}:

buildPythonPackage rec {
  pname = "batch-tamarin";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tamarin-prover";
    repo = "batch-tamarin";
    tag = "v${version}";
    hash = "sha256-vf4h/Zefac87C24rlSy7xnUH0rkrE+xNb8pBgAP6daU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    typer
    pydantic
    psutil
    tree-sitter
    py-tree-sitter-spthy
    diskcache
    jinja2
    graphviz
  ];

  # Tests require Tamarin Prover to be installed
  doCheck = false;
  
  # pythonImportsCheck disabled because package creates cache directory during import
  # which is not allowed in Nix sandbox
  pythonImportsCheck = [ ];

  meta = {
    description = "Python wrapper for Tamarin Prover with JSON configuration";
    homepage = "https://github.com/tamarin-prover/batch-tamarin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "batch-tamarin";
  };
}