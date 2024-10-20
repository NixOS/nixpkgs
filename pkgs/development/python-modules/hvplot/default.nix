{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools-scm,

  # dependencies
  bokeh,
  colorcet,
  holoviews,
  pandas,
}:

buildPythonPackage rec {
  pname = "hvplot";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mJ7QOJGJrcR+3NJgHS6rGL82bnSwf14oc+AhMjxKFLs=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    bokeh
    colorcet
    holoviews
    pandas
  ];

  # Many tests require a network connection
  doCheck = false;

  pythonImportsCheck = [ "hvplot.pandas" ];

  meta = {
    description = "High-level plotting API for the PyData ecosystem built on HoloViews";
    homepage = "https://hvplot.pyviz.org";
    changelog = "https://github.com/holoviz/hvplot/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
