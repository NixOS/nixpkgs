{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, geopandas
, matplotlib
, networkx
, numpy
, pandas
, pyproj
, requests
, Rtree
, shapely
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "1.2.3";
  disabled = pythonOlder "3.9";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gboeing";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W/L5FBo1PYE8zkaUO2a5d+f0laCklrIRVKaaMQyB+tM=";
  };

  propagatedBuildInputs = [
    geopandas
    matplotlib
    networkx
    numpy
    pandas
    pyproj
    requests
    Rtree
    shapely
  ];

  # requires network
  #doCheck = false;

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "osmnx" ];

  meta = with lib; {
    changelog = "https://github.com/gboeing/osmnx/blob/${src.rev}/CHANGELOG.md";
    description = "Retrieve, model, analyze, and visualize OpenStreetMap street networks and other spatial data";
    homepage = "https://github.com/gboeing/osmnx";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

