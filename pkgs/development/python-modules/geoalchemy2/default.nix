{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1viq85fsb119w4lmxn2iacxf2w35b8cgzamlrb685z50pp1cdi2d";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  http://geoalchemy.org/;
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
