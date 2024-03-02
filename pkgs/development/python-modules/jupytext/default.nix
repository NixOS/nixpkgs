{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, hatch-jupyter-builder
, hatchling
, jupyter-client
, markdown-it-py
, mdit-py-plugins
, nbformat
, notebook
, packaging
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aMe2hoXocOgOYP2oKG+9Ymnpx03B30MW32/kbqvJTJk=";
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
  ];

  propagatedBuildInputs = [
    markdown-it-py
    mdit-py-plugins
    nbformat
    packaging
    pyyaml
    toml
  ];

  nativeCheckInputs = [
    jupyter-client
    notebook
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    # Tests that use a Jupyter notebook require $HOME to be writable
    export HOME=$(mktemp -d);
    export PATH=$out/bin:$PATH;
  '';

  disabledTestPaths = [
    "tests/external"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # requires access to trash
    "test_load_save_rename"
  ];

  pythonImportsCheck = [
    "jupytext"
    "jupytext.cli"
  ];

  meta = with lib; {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = "https://github.com/mwouts/jupytext";
    changelog = "https://github.com/mwouts/jupytext/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = teams.jupyter.members;
    mainProgram = "jupytext";
  };
}
