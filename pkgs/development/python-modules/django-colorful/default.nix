{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-colorful";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd246f2fb297ed074dc4349966d33a1c82d0308b7fb0d6ef6e2e76b90cefffb7";
  };

  # Tests aren't run
  doCheck = false;

  # Requires Django >= 1.8
  buildInputs = [ django ];

  meta = with lib; {
    description = "Django extension that provides database and form color fields";
    homepage = "https://github.com/charettes/django-colorful";
    license = licenses.mit;
  };

}
