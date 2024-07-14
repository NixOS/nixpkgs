{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pexif";
  version = "0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RaO+A3x7qLZLv8SPNYZALMF95Vu51zV+8ryZlUoY2j8=";
  };

  meta = with lib; {
    description = "Module for editing JPEG EXIF data";
    homepage = "http://www.benno.id.au/code/pexif/";
    license = licenses.mit;
  };
}
