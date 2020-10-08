{ lib
, buildPythonPackage
, fetchPypi
, bokeh
, holoviews
, pandas
, pytest
, parameterized
, nbsmoke
, flake8
, coveralls
, xarray
, networkx
, streamz
, colorcet
, pythonImportsCheckHook
}:

buildPythonPackage rec {
  pname = "hvplot";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fcf2f251bd9d4b0390d9c272c992aa75e11174829e416a22de8fba38acc1ce9";
  };

  nativeBuildInputs = [
    pythonImportsCheckHook
  ];

  checkInputs = [ pytest parameterized nbsmoke flake8 coveralls xarray networkx streamz ];
  propagatedBuildInputs = [
    bokeh
    colorcet
    holoviews
    pandas
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # many tests require a network connection
  doCheck = false;

  pythonImportsCheck = [
    "hvplot.pandas"
  ];

  meta = with lib; {
    description = "A high-level plotting API for the PyData ecosystem built on HoloViews";
    homepage = "https://hvplot.pyviz.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
