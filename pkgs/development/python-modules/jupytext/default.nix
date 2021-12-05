{ lib
, buildPythonPackage
, fetchFromGitHub
, GitPython
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
  version = "1.13.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S2SKAC2oT4VIVMMDbu/Puo87noAgnQs1hh88JphutA8=";
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
    jupyter-client
    notebook
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/mwouts/jupytext/pull/885
    substituteInPlace setup.py \
      --replace "markdown-it-py[plugins]>=1.0.0b3,<2.0.0" "markdown-it-py[plugins]>=1.0"
  '';

  preCheck = ''
    # Tests that use a Jupyter notebook require $HOME to be writable
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    # Pre-commit tests expect the source directory to be a Git repository
    "--ignore-glob='tests/test_pre_commit_*.py'"
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
