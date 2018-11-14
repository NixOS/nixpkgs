{ stdenv, buildPythonPackage, fetchFromGitHub, geopandas, descartes, matplotlib, networkx, numpy
, pandas, requests, Rtree, shapely, pytest, coverage, coveralls, folium, scikitlearn, scipy}:

buildPythonPackage rec {
  pname = "osmnx";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner  = "gboeing";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1pn2v3dhbmb0yhqif9padg7x3sdx27pgfr95i3kxj4v0yrviaf9k";
  };

  propagatedBuildInputs = [ geopandas descartes matplotlib networkx numpy pandas requests Rtree shapely folium scikitlearn scipy ];

  checkInputs = [ coverage pytest coveralls ];
  #Fails when using sandboxing as it requires internet connection, works fine without it
  doCheck = false;

  #Check phase for the record
  #checkPhase = ''
  #  coverage run --source osmnx -m pytest --verbose
  #'';

  meta = with stdenv.lib; {
    description = "A package to easily download, construct, project, visualize, and analyze complex street networks from OpenStreetMap with NetworkX.";
    homepage = https://github.com/gboeing/osmnx;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

