{ lib
, buildPythonPackage
, fetchPypi
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
, jinja2
, tomli
, pythonOlder
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab";
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
  };
}
