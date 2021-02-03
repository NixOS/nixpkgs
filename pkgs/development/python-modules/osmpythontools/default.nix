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
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "mocnik-science";
    repo = "osm-python-tools";
    rev = "v${version}";
    sha256 = "1hkc18zcw1fqx8zk3z18xpas87vkcpgsch5cavqda4aihl51vmy2";
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
