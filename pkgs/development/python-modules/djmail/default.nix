{ lib, buildPythonPackage, fetchPypi,
  celery, django, psycopg2
}:

buildPythonPackage rec {
  pname = "djmail";
  name = "${pname}-${version}";
  version = "1.0.1";

  meta = {
    description = "Simple, powerfull and nonobstructive django email middleware.";
    homepage = https://github.com/bameda/djmail;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "1827i9qcn1ki09i5pg0lmar7cxjv18avh76x1n20947p1cimf3rp";
  };

  propagatedBuildInputs = [ celery django psycopg2 ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
