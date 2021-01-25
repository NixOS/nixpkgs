{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, django
}:

buildPythonPackage rec {
  pname = "django_evolution";
  version = "2.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "997efdc7f27248fd3c5e9eeccae1cfee046dfead037b171d30cbe6e91c9ca3d7";
  };

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "A database schema evolution tool for the Django web framework";
    homepage = "https://github.com/beanbaginc/django-evolution";
    license = licenses.bsd0;
    broken = true;
  };

}
