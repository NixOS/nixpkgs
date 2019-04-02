{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bzm9zgz2gfy6smlvdgxnf6y14rfhr4vj3mjfwlxdx2vcfc95hqa";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  http://geoalchemy.org/;
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
