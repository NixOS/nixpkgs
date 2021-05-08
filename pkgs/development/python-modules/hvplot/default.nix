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
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdb61183d3cdb1296c7f63c6aab59ee72b7b79b9ddc18abce2ebd3214e8de9db";
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
