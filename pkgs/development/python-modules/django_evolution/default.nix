{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, django
}:

buildPythonPackage rec {
  pname = "django_evolution";
  version = "0.7.5";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qbcx54hq8iy3n2n6cki3bka1m9rp39np4hqddrm9knc954fb7nv";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "A database schema evolution tool for the Django web framework";
    homepage = http://code.google.com/p/django-evolution/;
    license = licenses.bsd0;
  };

}
