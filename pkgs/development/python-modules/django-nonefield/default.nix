{ lib
# Dependencies
, django
, unidecode
, django-nine
# Build
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "django-nonefield";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lgDsayxL0J8YW6ykkoXogDCSJJ6BZaAvUKy+oLt1JBM=";
  };

  propagatedBuildInputs = [
    django
    django-nine
    unidecode
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "None field for Django.";
    homepage = "https://pypi.org/project/django-nonefield/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ sebastiaan ];
  };
}
