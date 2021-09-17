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
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74b269c6e118dd6f7d2a4039e91f16a193638f4119b4358dc6dbd58a2e71e432";
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
