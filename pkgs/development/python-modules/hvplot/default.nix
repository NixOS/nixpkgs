{
  lib,
  bokeh,
  buildPythonPackage,
  colorcet,
  fetchPypi,
  holoviews,
  pandas,
  pythonOlder,
  setuptools-scm,
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

  build-system = [ setuptools-scm ];

  dependencies = [
    bokeh
    colorcet
    holoviews
    pandas
  ];

  # Many tests require a network connection
  doCheck = false;

  pythonImportsCheck = [ "hvplot.pandas" ];

  meta = with lib; {
    description = "High-level plotting API for the PyData ecosystem built on HoloViews";
    homepage = "https://hvplot.pyviz.org";
    changelog = "https://github.com/holoviz/hvplot/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
