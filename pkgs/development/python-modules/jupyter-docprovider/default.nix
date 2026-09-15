{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-jupyter-builder,
  jupyter-builder,

  # passthru
  jupyter-collaboration,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-docprovider";
  version = "3.0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jupyter_docprovider";
    inherit (finalAttrs) version;
    hash = "sha256-9eyW7hKsTzT/pIvVdiYrJLUlkA+MzKK9cjTrzHGxM78=";
  };

  build-system = [
    hatchling
    hatch-jupyter-builder
    jupyter-builder
  ];

  pythonImportsCheck = [ "jupyter_docprovider" ];

  # no tests
  doCheck = false;

  passthru.tests = jupyter-collaboration;

  meta = {
    description = "JupyterLab/Jupyter Notebook 7+ extension integrating collaborative shared models";
    homepage = "https://github.com/jupyterlab/jupyter-collaboration/tree/main/projects/jupyter-docprovider";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
