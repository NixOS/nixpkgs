{ stdenv, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "049xj760s75nkvs7rhz710a6x3lvvfajddknmfz1vkf2p3f2l2as";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = https://github.com/GeospatialPython/pyshp;
    license = licenses.mit;
  };
}
