{ lib, buildPythonPackage, fetchFromGitHub, geopandas, descartes, matplotlib, networkx, numpy
, pandas, requests, Rtree, shapely, folium, scikitlearn, scipy}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "0.9";

  src = fetchFromGitHub {
    owner  = "gboeing";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1k3y5kl4k93vxaxyanc040x44s2fyyc3m1ndy2j3kg0037z8ad4z";
  };

  propagatedBuildInputs = [ geopandas descartes matplotlib networkx numpy pandas requests Rtree shapely folium scikitlearn scipy ];

  # requires network
  doCheck = false;
  pythonImportsCheck = [ "osmnx" ];

  meta = with lib; {
    description = "A package to easily download, construct, project, visualize, and analyze complex street networks from OpenStreetMap with NetworkX.";
    homepage = "https://github.com/gboeing/osmnx";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

