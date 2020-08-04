{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72fc53580a6b538f0cfff10f27f42333f67d79c406399289c94ec5a193cfb3e1";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
  };

}
