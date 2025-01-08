{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-jupyter-builder,
  hatchling,

  # dependencies
  markdown-it-py,
  mdit-py-plugins,
  nbformat,
  packaging,
  pyyaml,
  pythonOlder,
  tomli,

  # tests
  jupyter-client,
  notebook,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.16.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = "jupytext";
    tag = "v${version}";
    hash = "sha256-MkFTIHXpe0rYBJsaXwFqDEao+wSL2tG4JtPx1CjHGoY=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies = [
    markdown-it-py
    mdit-py-plugins
    nbformat
    packaging
    pyyaml
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    jupyter-client
    notebook
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  preCheck = ''
    # Tests that use a Jupyter notebook require $HOME to be writable
    export HOME=$(mktemp -d);
    export PATH=$out/bin:$PATH;
  '';

  disabledTestPaths = [
    # Requires the `git` python module
    "tests/external"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # requires access to trash
    "test_load_save_rename"
  ];

  pythonImportsCheck = [
    "jupytext"
    "jupytext.cli"
  ];

  meta = {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = "https://github.com/mwouts/jupytext";
    changelog = "https://github.com/mwouts/jupytext/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = lib.teams.jupyter.members;
    mainProgram = "jupytext";
  };
}
