{ lib, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.1.3";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e32b4a6832a3b97986df442df63b4c4a7dcc846b326c903189530a5cc6df0260";
  };

  buildInputs = [ setuptools ];

  meta = with lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
  };
}
