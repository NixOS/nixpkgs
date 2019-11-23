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
}:

buildPythonPackage rec {
  pname = "hvplot";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "408a7756b980df148d1f2fd59cd690ad4870d7e3c3c5e46c6b5c2e71fc6a097c";
  };

  checkInputs = [ pytest parameterized nbsmoke flake8 coveralls xarray networkx streamz ];
  propagatedBuildInputs = [
    bokeh
    holoviews
    pandas
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # many tests require a network connection
  doCheck = false;

  meta = with lib; {
    description = "A high-level plotting API for the PyData ecosystem built on HoloViews";
    homepage = https://hvplot.pyviz.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
