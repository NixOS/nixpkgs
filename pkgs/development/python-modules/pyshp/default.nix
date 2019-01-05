{ stdenv, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l5a28878vplwclqvjj7v0xx6zlr03ia1dkq5hc3mxf05bahiwyz";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = https://github.com/GeospatialPython/pyshp;
    license = licenses.mit;
  };
}
