{
  lib,
  buildPythonPackage,
  fetchurl,
}:

buildPythonPackage rec {
  pname = "gdata";
  version = "2.0.18";
  format = "setuptools";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gdata-python-client/${pname}-${version}.tar.gz";
    hash = "sha256-VufSLegZwisTzrD+GGlym0KH+J671LtVOA17z2Gh/bY=";
  };

  # Fails with "error: invalid command 'test'"
  doCheck = false;

  meta = {
    homepage = "https://github.com/google/gdata-python-client";
    description = "Python client library for Google data APIs";
    license = lib.licenses.asl20;
  };
}
