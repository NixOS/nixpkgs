{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  geojson,
  lxml,
  matplotlib,
  numpy,
  pandas,
  ujson,
  xarray,
}:

buildPythonPackage rec {
  pname = "osmpythontools";
  version = "0.3.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mocnik-science";
    repo = "osm-python-tools";
    rev = "v${version}";
    hash = "sha256-lTDA1Rad9aYI/ymU/0xzdJHmebUGcpVJ0GW7D0Ujdko=";
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
    changelog = "https://raw.githubusercontent.com/mocnik-science/osm-python-tools/v${version}/version-history.md";
    maintainers = with maintainers; teams.geospatial.members ++ [ das-g ];
  };
}
