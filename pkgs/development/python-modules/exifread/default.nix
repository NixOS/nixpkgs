{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "exifread";
  version = "3.4.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "ExifRead";
    inherit version;
    hash = "sha256-3H+Np3OWcJykFKDu4cJikC9xOvycBDuqi4IzfXYwb/w=";
  };

  meta = with lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    mainProgram = "EXIF.py";
    homepage = "https://github.com/ianare/exif-py";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
