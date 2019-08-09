{ stdenv, buildPythonPackage, fetchFromGitHub
, pandas, shapely, fiona, descartes, pyproj
, pytest, Rtree }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.5.1";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "1j665fpkyfib17z0hn3bg2j96pbkgd36yfif6jyia4yn6g76hlfg";
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
