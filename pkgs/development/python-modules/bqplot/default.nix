{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, jupyter-packaging
, jupyterlab
, bqscales
, ipywidgets
, numpy
, pandas
, traitlets
, traittypes
}:

buildPythonPackage rec {
  pname = "bqplot";
  version = "0.12.39";

  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FNjeb5pNGUW76mwTIOpNHJMlb3JoN3T24AINzFefPdI=";
  };

  # upstream seems in flux for 0.13 release. they seem to want to migrate from
  # jupyter_packaging to hatch, so let's patch instead of fixing upstream
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "jupyter_packaging~=" "jupyter_packaging>=" \
      --replace "jupyterlab~=" "jupyterlab>="
  '';

  nativeBuildInputs = [
    jupyter-packaging
    jupyterlab
  ];

  propagatedBuildInputs = [
    bqscales
    ipywidgets
    numpy
    pandas
    traitlets
    traittypes
  ];

  # no tests in PyPI dist, and not obvious to me how to build the js files from GitHub
  doCheck = false;

  pythonImportsCheck = [
    "bqplot"
    "bqplot.pyplot"
  ];

  meta = {
    description = "2D plotting library for Jupyter based on Grammar of Graphics";
    homepage = "https://bqplot.github.io/bqplot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
