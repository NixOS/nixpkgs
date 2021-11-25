{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.7.2";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = "https://github.com/SmileyChris/easy-thumbnails";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7dd9cf97efaf70ba5d76484a962f08ba65b31f1681bc417257743650e9e8a8a";
  };

  propagatedBuildInputs = [ django pillow ];
}
