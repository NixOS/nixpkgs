{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ExifRead";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CsWjZBadvfK9YvlPXAc5cKtmlKMWYXf15EixDJQ+LKQ=";
  };

  meta = with lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    homepage    = "https://github.com/ianare/exif-py";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };

}
