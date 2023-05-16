{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, hatch-jupyter-builder
, hatchling
, async-lru
, packaging
, tornado
, ipykernel
, jupyter-core
, jupyter-lsp
, jupyterlab_server
, jupyter-server
, notebook-shim
=======
, ipython
, packaging
, tornado
, jupyter-core
, jupyterlab_server
, jupyter-server
, jupyter-server-ydoc
, notebook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, jinja2
, tomli
, pythonOlder
, jupyter-packaging
<<<<<<< HEAD
=======
, pythonRelaxDepsHook
, nbclassic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jupyterlab";
<<<<<<< HEAD
  version = "4.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4U0c5GphMCgRHQ1Hah19awlAA7dGK6xmn1tHgxeryzk=";
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
  ];

  propagatedBuildInputs = [
    async-lru
    packaging
    tornado
    ipykernel
    jupyter-core
    jupyter-lsp
    jupyterlab_server
    jupyter-server
    notebook-shim
=======
  version = "3.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nz6c+4py7dKUvhTxZmJWOiIM7PD7Jt56qxr5optom4I=";
  };

  nativeBuildInputs = [
    jupyter-packaging
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "jupyter-ydoc"
    "jupyter-server-ydoc"
  ];

  propagatedBuildInputs = [
    ipython
    packaging
    tornado
    jupyter-core
    jupyterlab_server
    jupyter-server
    jupyter-server-ydoc
    nbclassic
    notebook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    jinja2
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  makeWrapperArgs = [
    "--set"
    "JUPYTERLAB_DIR"
    "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [
    "jupyterlab"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/v${version}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = licenses.bsd3;
    homepage = "https://jupyter.org/";
    maintainers = lib.teams.jupyter.members;
=======
    changelog = "https://github.com/jupyterlab/jupyterlab/releases/tag/v${version}";
    description = "Jupyter lab environment notebook server extension";
    license = with licenses; [ bsd3 ];
    homepage = "https://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
