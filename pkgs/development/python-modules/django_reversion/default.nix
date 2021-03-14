{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5af55f086a3f9c38be2f049c251e06005b9ed48ba7a109473736b1fc95a066f";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
  };

}
