{ lib, buildPythonPackage, fetchPypi, django, django-appconf }:

buildPythonPackage rec {
  pname = "django-statici18n";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbcdac190d93e0b4eabcab8875c8eb68795eceb442f926843ec5cbe1432fe628";
  };

  propagatedBuildInputs = [ django django-appconf ];

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
