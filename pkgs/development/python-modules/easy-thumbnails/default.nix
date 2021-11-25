{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.8";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = "https://github.com/SmileyChris/easy-thumbnails";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd2249d936671847fc54a2d6c8c87bcca8f803001967dd03bab6b8bcb7590825";
  };

  propagatedBuildInputs = [ django pillow ];
}
