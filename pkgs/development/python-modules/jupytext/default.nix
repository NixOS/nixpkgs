{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, GitPython
, jupyter-packaging
, jupyter-client
, jupyterlab
, markdown-it-py
, mdit-py-plugins
, nbformat
, notebook
, pytestCheckHook
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.11.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S2SKAC2oT4VIVMMDbu/Puo87noAgnQs1hh88JphutA8=";
  };

  buildInputs = [ jupyter-packaging jupyterlab ];
  propagatedBuildInputs = [
    markdown-it-py
    mdit-py-plugins
    nbformat
    pyyaml
    toml
  ];

  checkInputs = [
    pytestCheckHook
    GitPython
    jupyter-client
    notebook
  ];
  # Tests that use a Jupyter notebook require $HOME to be writable.
  HOME = "$TMPDIR";
  # Pre-commit tests expect the source directory to be a Git repository.
  pytestFlagsArray = [ "--ignore-glob='tests/test_pre_commit_*.py'" ];
  pythonImportsCheck = [ "jupytext" "jupytext.cli" ];

  meta = with lib; {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = "https://github.com/mwouts/jupytext";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
