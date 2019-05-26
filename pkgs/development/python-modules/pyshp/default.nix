{ stdenv, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h75a5fisqqj48m6wq7jhdxv6arjg3mvnr5q404pvfbjscj7yp76";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = https://github.com/GeospatialPython/pyshp;
    license = licenses.mit;
  };
}
