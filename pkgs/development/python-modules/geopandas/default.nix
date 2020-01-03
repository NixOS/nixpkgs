{ stdenv, buildPythonPackage, fetchFromGitHub
, pandas, shapely, fiona, descartes, pyproj
, pytest, Rtree }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "1wy2n204vf5bbswgma205lr1is7nnxr385m4x3v7pra05bq8ag3q";
  };

  checkInputs = [ pytest Rtree ];

  checkPhase = ''
    py.test geopandas -m "not web"
  '';

  propagatedBuildInputs = [
    pandas
    shapely
    fiona
    descartes
    pyproj
  ];

  meta = with stdenv.lib; {
    description = "Python geospatial data analysis framework";
    homepage = "http://geopandas.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
