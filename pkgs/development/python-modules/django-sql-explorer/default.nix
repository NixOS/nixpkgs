{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi
, six, django, sqlparse, unicodecsv }:

buildPythonPackage rec {
  pname = "django-sql-explorer";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kpaz4ch3m4i9jmqwkjcinjlqypqab02sh97vvig8dqhlmrbkrv5";
  };

  propagatedBuildInputs = [ six django sqlparse unicodecsv ];

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  meta = with lib; {
    description = "Quickly write and share SQL queries in a simple, usable SQL editor";
    homepage = https://github.com/groveco/django-sql-explorer;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = with licenses; [ mit ];
  };
}
