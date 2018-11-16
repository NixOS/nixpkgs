{ stdenv, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "1.2.12";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dcd65e0aa2aa2951527ddb7339ea6e69023543d8a20a73fc51e2829b9ed6179";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = https://github.com/GeospatialPython/pyshp;
    license = licenses.mit;
  };
}
