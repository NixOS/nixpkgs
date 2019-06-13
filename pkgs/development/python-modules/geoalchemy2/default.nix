{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h04qqdzyflprgf93ihn707brx61f3my5bfdqkwllhwxvr935jyb";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  http://geoalchemy.org/;
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
