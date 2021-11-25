{ lib, buildPythonPackage, fetchPypi, django, django_appconf }:

buildPythonPackage rec {
  pname = "django-statici18n";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c85192fa95e3ef3727517ac104add8959fc0a54be3d13440a8a3319fddbc778";
  };

  propagatedBuildInputs = [ django django_appconf ];

  # pypi package does not contains test harness
  # source tarball requires setting up a config
  doCheck = false;

  meta = with lib; {
    description = "Helper for generating Javascript catalog to static files";
    homepage = "https://github.com/zyegfryed/django-statici18n";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
