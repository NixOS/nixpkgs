{ stdenv
, buildPythonPackage
, fetchPypi
, sqlalchemy
, shapely
}:

buildPythonPackage rec {
  pname = "GeoAlchemy2";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d66d01af82d22bc37d3ebb1e73713b87ac5e116b3bc82ea4ec0584bbaa89f89";
  };

  propagatedBuildInputs = [ sqlalchemy shapely ];

  meta = with stdenv.lib; {
    homepage =  http://geoalchemy.org/;
    license = licenses.mit;
    description = "Toolkit for working with spatial databases";
  };

}
