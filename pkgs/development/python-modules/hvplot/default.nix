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
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6HSGqVv+FRq1LvFjpek9nL0EOZLPC3Vcyt0r82/t03Y=";
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
