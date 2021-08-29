{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, django
}:

buildPythonPackage rec {
  pname = "django_evolution";
  version = "2.1.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "28bad07b5e29a0ea4bd9727c6927cbee25d349d21606a553a0c748fbee0c073c";
  };

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "A database schema evolution tool for the Django web framework";
    homepage = "https://github.com/beanbaginc/django-evolution";
    license = licenses.bsd0;
    broken = true;
  };

}
