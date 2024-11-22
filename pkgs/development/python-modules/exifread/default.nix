{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "exifread";
  version = "3.0.0";

  src = fetchPypi {
    pname = "ExifRead";
    inherit version;
    hash = "sha256-CsWjZBadvfK9YvlPXAc5cKtmlKMWYXf15EixDJQ+LKQ=";
  };

  meta = with lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    mainProgram = "EXIF.py";
    homepage = "https://github.com/ianare/exif-py";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
