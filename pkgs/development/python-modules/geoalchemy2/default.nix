{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lnmj9jky9pz227scmjxgvd8243higl24ndc0cc668mm36cnwapc";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  http://geoalchemy.org/;
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
