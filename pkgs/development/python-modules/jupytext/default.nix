{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, GitPython
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
    sha256 = "sha256-DDF4aTLkhEl4xViYh/E0/y6swcwZ9KbeS0qKm+HdFz8=";
  };

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

  checkInputs = [
    GitPython
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
