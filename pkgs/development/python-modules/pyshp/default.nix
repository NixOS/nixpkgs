{ stdenv, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.1.2";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0aa668cd0fc09b873f10facfe96971c0496b7fe4f795684d96cc7306ac5841c";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
  };
}
