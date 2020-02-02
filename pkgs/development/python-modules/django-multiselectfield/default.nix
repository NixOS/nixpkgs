{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "043fa1aaddceb9b170c64c0745dc3a059165dcbc74946a434340778f63efa3c2";
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