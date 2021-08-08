{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, geopandas, matplotlib, networkx, numpy
, pandas, requests, Rtree, shapely, folium, scikit-learn, scipy, gdal, rasterio}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "1.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner  = "gboeing";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0dkv3fnlq23d7d30lhdf4a313lxy3a5qfldidvszs1z9n16ycnwb";
  };

  propagatedBuildInputs = [ geopandas matplotlib networkx numpy pandas requests Rtree shapely folium scikit-learn scipy gdal rasterio ];

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

