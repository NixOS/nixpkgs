{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5a2444d90ce7f2c6b2d7bd7346c8aed16fd32c3e190e631576a51814e8f7ee9";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  "http://geoalchemy.org/";
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
