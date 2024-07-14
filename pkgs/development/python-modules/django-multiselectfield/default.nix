{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0KTHFWj7IzLHFHj/rJ+HCOATFKNc+SPf16GRNDRS+fk=";
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
