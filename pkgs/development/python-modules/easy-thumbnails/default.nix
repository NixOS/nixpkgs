{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.6";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = https://github.com/SmileyChris/easy-thumbnails;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "23fbe3415c93b2369ece8ebdfb5faa05540943bef8b941b3118ce769ba95e275";
  };

  propagatedBuildInputs = [ django pillow ];
}
