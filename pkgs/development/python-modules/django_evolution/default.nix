{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, django
}:

buildPythonPackage rec {
  pname = "django_evolution";
  version = "2.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0bc983657de1b0bc5c8d29ddcbf7b6fb113685bf306ccc266cf22b8a77bd862";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "A database schema evolution tool for the Django web framework";
    homepage = "https://github.com/beanbaginc/django-evolution";
    license = licenses.bsd0;
    broken = true;
  };

}
