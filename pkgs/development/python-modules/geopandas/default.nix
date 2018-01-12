{ stdenv, buildPythonPackage, fetchFromGitHub
, pandas, shapely, fiona, descartes, pyproj
, pytest }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.3.0";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "0maafafr7sjjmlg2f19bizg06c8a5z5igmbcgq6kgmi7rklx8xxz";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test geopandas
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
