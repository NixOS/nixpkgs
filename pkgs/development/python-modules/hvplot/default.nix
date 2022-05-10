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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hjDbo0lpsQXiZ8vhQjfi1W2ZacgBmArl5RkLwYsnktY=";
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
