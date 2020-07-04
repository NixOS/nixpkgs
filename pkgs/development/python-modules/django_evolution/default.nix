{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, django
}:

buildPythonPackage rec {
  pname = "django_evolution";
  version = "0.7.8";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "493ff2adad760990ce8cf87c13955af85d4dcff097427bc3619ed01672fac4a8";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "A database schema evolution tool for the Django web framework";
    homepage = "https://github.com/beanbaginc/django-evolution";
    license = licenses.bsd0;
    broken = true;
  };

}
