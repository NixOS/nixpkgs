{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.5";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = https://github.com/SmileyChris/easy-thumbnails;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "e244d1f26027fc32c6ca60ffb0169a39099446f614b0433e907a2588ae7d9b95";
  };

  propagatedBuildInputs = [ django pillow ];
}
