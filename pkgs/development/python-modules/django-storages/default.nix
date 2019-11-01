{ stdenv, buildPythonPackage, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01xq232h321716r08rari9payas7fsiwwr5q6zgcrlwkckwxxczk";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of custom storage backends for Django";
    homepage = https://django-storages.readthedocs.io;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
