{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, pandas, shapely, fiona, descartes, pyproj
, pytest, Rtree }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.8.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "033jygbyycl9s6b0kqix9xynhapc2xd8nh47kcfacn514gyncgah";
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
    homepage = "https://geopandas.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
