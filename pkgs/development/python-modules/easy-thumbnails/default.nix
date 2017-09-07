{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  name = "${pname}-${version}";
  version = "2.4.1";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = https://github.com/SmileyChris/easy-thumbnails;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w228b6hx8k4r15v7z62hyg99qp6xp4mdkgqs1ah64fyqxp1riaw";
  };

  propagatedBuildInputs = [ django pillow ];
}
