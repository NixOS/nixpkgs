{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  async-lru,
  httpx,
  importlib-metadata,
  ipykernel,
  jinja2,
  jupyter-core,
  jupyter-lsp,
  jupyter-server,
  jupyterlab-server,
  notebook-shim,
  packaging,
  setuptools,
  tomli,
  tornado,
  traitlets,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "4.3.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8LubCaBHZuNCPMzC/CMWmqL/7c34cT6eD7M8rAtoWdA=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies =
    [
      async-lru
      httpx
      ipykernel
      jinja2
      jupyter-core
      jupyter-lsp
      jupyter-server
      jupyterlab-server
      notebook-shim
      packaging
      setuptools
      tornado
      traitlets
    ]
    ++ lib.optionals (pythonOlder "3.11") [ tomli ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  makeWrapperArgs = [
    "--set"
    "JUPYTERLAB_DIR"
    "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab" ];

  meta = with lib; {
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/v${version}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = licenses.bsd3;
    homepage = "https://jupyter.org/";
    maintainers = lib.teams.jupyter.members;
    mainProgram = "jupyter-lab";
  };
}
