{ stdenv, buildPythonPackage, fetchFromGitHub
, pandas, shapely, fiona, descartes, pyproj
, pytest, Rtree }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.4.1";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "02v3lszxvhpsb0qrqk0kcnf9jss9gdj8az2r97aqx7ya8cwaccxa";
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
    homepage = https://geopandas.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
