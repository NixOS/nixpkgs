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
  version = "0.2.8";

  src = fetchPypi {
    pname = "OSMPythonTools";
    inherit version;
    sha256 = "8a33adbd266127e342d12da755075fae08f398032a6f0909b5e86bef13960a85";
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
