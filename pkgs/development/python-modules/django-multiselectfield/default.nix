{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec305ca79b6e16fb6d699d3159258f9f680ead8ea5ef9b419e7faf13f31355df";
  };

  propagatedBuildInputs = [ django ];

  # No tests
  doCheck = false;

  meta = {
    description = "django-multiselectfield";
    homepage = "https://github.com/goinnn/django-multiselectfield";
    license = lib.licenses.lgpl3;
  };
}