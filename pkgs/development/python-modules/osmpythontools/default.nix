{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, geojson
, lxml
, matplotlib
, numpy
, pandas
, ujson
, xarray
}:

buildPythonPackage rec {
  pname = "osmpythontools";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mocnik-science";
    repo = "osm-python-tools";
    rev = "v${version}";
    sha256 = "1m5ai9h1zbp79x0vb138fmyh2hg8lqp859s7j33lra9hds6wb40a";
  };

  # Upstream setup.py has test dependencies in `install_requires` argument.
  # Remove them, as we don't run the tests.
  patches = [ ./remove-test-only-dependencies.patch ];

  propagatedBuildInputs = [
    beautifulsoup4
    geojson
    lxml
    matplotlib
    numpy
    pandas
    ujson
    xarray
  ];

  # tests touch network
  doCheck = false;

  pythonImportsCheck = [
    "OSMPythonTools"
    "OSMPythonTools.api"
    "OSMPythonTools.data"
    "OSMPythonTools.element"
    "OSMPythonTools.nominatim"
    "OSMPythonTools.overpass"
  ];

  meta = with lib; {
    description = "A library to access OpenStreetMap-related services";
    longDescription = ''
      The python package OSMPythonTools provides easy access to
      OpenStreetMap-related services, among them an Overpass endpoint,
      Nominatim, and the OpenStreetMap editing API.
    '';
    homepage = "https://github.com/mocnik-science/osm-python-tools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ das-g ];
  };
}
