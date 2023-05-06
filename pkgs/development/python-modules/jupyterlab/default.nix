{ lib
, buildPythonPackage
, fetchPypi
, ipython
, packaging
, tornado
, jupyter-core
, jupyterlab_server
, jupyter-server
, jupyter-server-ydoc
, notebook
, jinja2
, tomli
, pythonOlder
, jupyter-packaging
, pythonRelaxDepsHook
, nbclassic
}:

buildPythonPackage rec {
  pname = "jupyterlab";
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
    changelog = "https://github.com/jupyterlab/jupyterlab/releases/tag/v${version}";
    description = "Jupyter lab environment notebook server extension";
    license = with licenses; [ bsd3 ];
    homepage = "https://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
  };
}
