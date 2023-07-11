{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, gitpython
, isort
, jupyter-client
, jupyter-packaging
, jupyterlab
, markdown-it-py
, mdit-py-plugins
, nbformat
, notebook
, pytestCheckHook
, pythonOlder
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.14.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DDF4aTLkhEl4xViYh/E0/y6swcwZ9KbeS0qKm+HdFz8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mwouts/jupytext/commit/be9b65b03600227b737b5f10ea259a7cdb762b76.patch";
      hash = "sha256-3klx8I+T560EVfsKe/FlrSjF6JzdKSCt6uhAW2cSwtc=";
    })
  ];

  buildInputs = [
    jupyter-packaging
    jupyterlab
  ];

  propagatedBuildInputs = [
    markdown-it-py
    mdit-py-plugins
    nbformat
    pyyaml
    toml
  ];

  nativeCheckInputs = [
    gitpython
    isort
    jupyter-client
    notebook
    pytestCheckHook
  ];

  preCheck = ''
    # Tests that use a Jupyter notebook require $HOME to be writable
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    # Pre-commit tests expect the source directory to be a Git repository
    "--ignore-glob='tests/test_pre_commit_*.py'"
  ];

  disabledTests = [
    "test_apply_black_through_jupytext" # we can't do anything about ill-formatted notebooks
  ] ++ lib.optionals stdenv.isDarwin [
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
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
