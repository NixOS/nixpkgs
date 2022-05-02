{ lib, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.3.0";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-glBk6kA6zxNehGz4sJJEmUMOa+HNN6DzS+cTCQZhfTw=";
  };

  buildInputs = [ setuptools ];

  meta = with lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
  };
}
