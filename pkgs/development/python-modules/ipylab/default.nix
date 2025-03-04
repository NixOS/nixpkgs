{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  ipywidgets,
  jupyterlab,
}:

buildPythonPackage rec {
  pname = "ipylab";
  version = "1.0.0";
  pyproject = true;

  # This needs to be fetched from Pypi, as we rely on the nodejs build to be skipped,
  # which only happens if ipylab/labextension/style.js is present.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xPB0Sx+W1sRgW5hqpZ68zWRFG/cclIOgGat6UsVlYXA=";
  };

  build-system = [
    hatchling
    hatch-jupyter-builder
    hatch-nodejs-version
    jupyterlab
  ];

  dependencies = [
    ipywidgets
  ];

  pythonImportsCheck = [ "ipylab" ];

  # There are no tests
  doCheck = false;

  meta = {
    description = "Control JupyterLab from Python notebooks.";
    homepage = "https://github.com/jtpio/ipylab";
    changelog = "https://github.com/jtpio/ipylab/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
