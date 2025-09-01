{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "exifread";
  version = "3.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3H+Np3OWcJykFKDu4cJikC9xOvycBDuqi4IzfXYwb/w=";
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
