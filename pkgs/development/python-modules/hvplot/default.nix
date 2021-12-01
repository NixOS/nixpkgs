{ lib
, bokeh
, buildPythonPackage
, colorcet
, fetchPypi
, holoviews
, pandas
, pythonImportsCheckHook
}:

buildPythonPackage rec {
  pname = "hvplot";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74b269c6e118dd6f7d2a4039e91f16a193638f4119b4358dc6dbd58a2e71e432";
  };

  nativeBuildInputs = [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [
    bokeh
    colorcet
    holoviews
    pandas
  ];

  # Many tests require a network connection
  doCheck = false;

  pythonImportsCheck = [
    "hvplot.pandas"
  ];

  meta = with lib; {
    description = "A high-level plotting API for the PyData ecosystem built on HoloViews";
    homepage = "https://hvplot.pyviz.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
