{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, setuptools
, toml
, wheel
=======
, toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jupytext";
<<<<<<< HEAD
  version = "1.15.1";
=======
  version = "1.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-XGjAPeMtg2Epu85JiqQPyZJVez5Z8uA+E40SFcZM7WY=";
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/mwouts/jupytext/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = teams.jupyter.members;
=======
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
