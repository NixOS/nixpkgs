{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XTO6lE2/GccDDJ5w43MSSK40Nozyr+3hDg0I+/ieb4w=";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "reversion" ];

  meta = with lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
