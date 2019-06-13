{ lib, buildPythonPackage, fetchPypi
, glibcLocales
, celery, django, psycopg2
}:

buildPythonPackage rec {
  pname = "djmail";
  version = "1.1.0";

  meta = {
    description = "Simple, powerfull and nonobstructive django email middleware";
    homepage = https://github.com/bameda/djmail;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "87d2a8b4bdf67ae9b312e127ccc873a53116cf297ec786460d782ce82eaa76b5";
  };

  nativeBuildInputs = [ glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [ celery django psycopg2 ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
