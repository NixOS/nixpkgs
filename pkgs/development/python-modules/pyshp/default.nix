{ stdenv, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "1.2.3";
  pname = "pyshp";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e18cc19659dadc5ddaa891eb780a6958094da0cf105a1efe0f67e75b4fa1cdf9";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = https://github.com/GeospatialPython/pyshp;
    license = licenses.mit;
  };
}
