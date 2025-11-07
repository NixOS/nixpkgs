{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "exifread";
  version = "3.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n5mPgNMGJ0HJdt/E/QM0JLxAkyk3mU5NIYHrcMS2rt0=";
  };

  build-system = [ setuptools ];

  meta = with lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    mainProgram = "EXIF.py";
    homepage = "https://github.com/ianare/exif-py";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
