{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-jupyter-builder,
  jupyterlab,
  ipywidgets,
  numpy,
  traitlets,
  traittypes,
}:

buildPythonPackage rec {
  pname = "bqscales";
  version = "0.3.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BhSIxo77oEa6Fmu7n4fIkIyTsLvhpGNsNspoBVOhIcE=";
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
    ipywidgets
    numpy
    traitlets
    traittypes
  ];

  env.SKIP_JUPYTER_BUILDER = 1;

  # no tests in PyPI dist
  doCheck = false;

  pythonImportsCheck = [ "bqscales" ];

  meta = {
    description = "Grammar of Graphics scales for bqplot and other Jupyter widgets libraries";
    homepage = "https://github.com/bqplot/bqscales";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
