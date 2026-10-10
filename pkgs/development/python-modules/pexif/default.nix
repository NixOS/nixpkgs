{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "pexif";
  version = "0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RaO+A3x7qLZLv8SPNYZALMF95Vu51zV+8ryZlUoY2j8=";
  };

  meta = {
    description = "Module for editing JPEG EXIF data";
    homepage = "http://www.benno.id.au/code/pexif/";
    license = lib.licenses.mit;
  };
})
