{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p2h1kgl5b0jz8wadx485vjh1mmm5s67p71yxh9lhp1441hkfswf";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  http://geoalchemy.org/;
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
