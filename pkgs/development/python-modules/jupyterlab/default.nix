{ lib
, buildPythonPackage
, fetchPypi
, hatch-jupyter-builder
, hatchling
, async-lru
, httpx
, packaging
, tornado
, ipykernel
, jupyter-core
, jupyter-lsp
, jupyterlab-server
, jupyter-server
, notebook-shim
, jinja2
, tomli
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "4.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ya11KQyxC/r/NiS/P7uFIxm0zOTEVmE/jruqmNA1JNs=";
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
  ];

  propagatedBuildInputs = [
    async-lru
    httpx
    packaging
    tornado
    ipykernel
    jupyter-core
    jupyter-lsp
    jupyterlab-server
    jupyter-server
    notebook-shim
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
    changelog = "https://github.com/jupyterlab/jupyterlab/blob/v${version}/CHANGELOG.md";
    description = "Jupyter lab environment notebook server extension";
    license = licenses.bsd3;
    homepage = "https://jupyter.org/";
    maintainers = lib.teams.jupyter.members;
    mainProgram = "jupyter-lab";
  };
}
