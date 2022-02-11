{ lib, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Dtogm9YvM0VwHE9nmbY4wRTOtn/uKClc3bThyvBT6UQ=";
  };

  buildInputs = [ setuptools ];

  meta = with lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
  };
}
