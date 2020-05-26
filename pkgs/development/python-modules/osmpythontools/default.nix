{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.2.6";

  src = fetchPypi {
    pname = "OSMPythonTools";
    inherit version;
    sha256 = "efc72e3963971c6c7fd94bd374704a5b78eb6c07397a4ffb5f9176c1e4aee096";
  };

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

  patches = [ ./remove-unused-dependency.patch ];

  # no tests included
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ das-g ];
  };
}
