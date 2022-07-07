{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, geopandas, matplotlib, networkx, numpy
, pandas, requests, Rtree, shapely, folium, scikit-learn, scipy, gdal, rasterio}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "1.2.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner  = "gboeing";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-HfgMmPEiKstMXV0rtul8QLxB1FY32Ws7IEonBB+qZOc=";
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

