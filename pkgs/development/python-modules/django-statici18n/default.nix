{ stdenv, lib, buildPythonPackage, fetchPypi, django, django_appconf }:

buildPythonPackage rec {
  pname = "django-statici18n";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cqwfirzjbanibq3mfz9lcwqnc8655zpysf9hk9g3lbwj2m478sp";
  };

  propagatedBuildInputs = [ django django_appconf ];

  # pypi package does not contains test harness
  doCheck = false;

  meta = {
    description = "Helper for generating Javascript catalog to static files";
    homepage = "https://github.com/zyegfryed/django-statici18n";
    maintainers = with lib.maintainers; [ greizgh schmittlauch ];
  };
}
