{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1add55bb05311f4acd26683dd71af60729d4f33dfe42c608da8e15e679a32009";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = https://github.com/etianen/django-reversion;
    license = licenses.bsd3;
  };

}
