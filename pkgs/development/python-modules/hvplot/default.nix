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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c709bebb737ebd71a0433f2333ed15f03dd3c431d4646c41c2b9fcbae4a29b7";
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
