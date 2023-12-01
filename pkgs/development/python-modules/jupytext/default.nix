{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
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
, setuptools
, toml
, wheel
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.15.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GvMoz2BsYWk0atrT3xmSnbV7AuO5RJoM/bOJlZ5YIn4=";
  };

  # Follow https://github.com/mwouts/jupytext/pull/1119 to see if the patch
  # relaxing jupyter_packaging version can be cleaned up.
  #
  # Follow https://github.com/mwouts/jupytext/pull/1077 to see when the patch
  # relaxing jupyterlab version can be cleaned up.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jupyter_packaging~=' 'jupyter_packaging>=' \
      --replace 'jupyterlab>=3,<=4' 'jupyterlab>=3'
  '';

  nativeBuildInputs = [
    jupyter-packaging
    jupyterlab
    setuptools
    wheel
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
    changelog = "https://github.com/mwouts/jupytext/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = teams.jupyter.members;
  };
}
