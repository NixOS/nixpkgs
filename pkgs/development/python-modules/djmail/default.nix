{
  lib,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
  celery,
  django,
  psycopg2,
}:

buildPythonPackage rec {
  pname = "djmail";
  version = "2.0.0";
  format = "setuptools";

  meta = {
    description = "Simple, powerfull and nonobstructive django email middleware";
    homepage = "https://github.com/bameda/djmail";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf3ce7626305d218a8bf2b6a219266ef8061aceeefc1c70a54170f4105465202";
  };

  nativeBuildInputs = [ glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [
    celery
    django
    psycopg2
  ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
