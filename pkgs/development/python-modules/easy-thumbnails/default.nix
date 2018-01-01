{ lib, buildPythonPackage, fetchPypi,
  django, pillow
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  name = "${pname}-${version}";
  version = "2.4.2";

  meta = {
    description = "Easy thumbnails for Django";
    homepage = https://github.com/SmileyChris/easy-thumbnails;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cad7ea4fb2b800284e842d8a44f685cbc1968535be04c24a4bbf6e6dbc550c4";
  };

  propagatedBuildInputs = [ django pillow ];
}
