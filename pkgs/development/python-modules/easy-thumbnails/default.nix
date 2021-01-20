{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.7.1";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = "https://github.com/SmileyChris/easy-thumbnails";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "f862949208d9066cd3d84ffcf9c2dbe9c7344ea6152b741e440f861eca46855c";
  };

  propagatedBuildInputs = [ django pillow ];
}
