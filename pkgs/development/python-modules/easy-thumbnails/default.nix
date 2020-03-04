{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.7";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = https://github.com/SmileyChris/easy-thumbnails;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4e7a0dd4001f56bfd4058428f2c91eafe27d33ef3b8b33ac4e013b159b9ff91";
  };

  propagatedBuildInputs = [ django pillow ];
}
