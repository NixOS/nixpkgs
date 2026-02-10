{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-jupyter-builder,
  jupyter-collaboration,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyter-collaboration-ui";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_collaboration_ui";
    inherit (finalAttrs) version;
    hash = "sha256-KpqOmQz10rp4+pkzRWhpHEaBXrcp4XM5JWzHplJioZY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "jupyterlab>=4.0.0"' ""
  '';

  build-system = [
    hatchling
    hatch-jupyter-builder
  ];

  pythonImportsCheck = [ "jupyter_collaboration_ui" ];

  # no tests
  doCheck = false;

  passthru.tests = jupyter-collaboration;

  meta = {
    description = "JupyterLab/Jupyter Notebook 7+ extension providing user interface integration for real time collaboration";
    homepage = "https://github.com/jupyterlab/jupyter-collaboration/tree/main/projects/jupyter-collaboration-ui";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
