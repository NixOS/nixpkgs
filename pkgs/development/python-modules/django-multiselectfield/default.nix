{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54fa3886884cbc5d9c2f523e0e4af2cc3b976bd077718b2b443a5be44eb481ec";
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