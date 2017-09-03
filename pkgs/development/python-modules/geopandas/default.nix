{ stdenv, buildPythonPackage, fetchPypi,
  pandas, shapely, fiona, descartes, pyproj }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02wj58aqyq1nr0axz2vci72zvpkmalrj570lrndqqvai7qmb6fz6";
  };

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
