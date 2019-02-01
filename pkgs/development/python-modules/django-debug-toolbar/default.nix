{ stdenv, lib, buildPythonPackage, fetchPypi
, django, sqlparse }:

buildPythonPackage rec {
  pname = "django-debug-toolbar";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dipzh82lh3qs9igbb37dhw763mzbxz9g3b84kxn7csxqrh5pmw9";
  };

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  propagatedBuildInputs = [ django sqlparse ];

  meta = with lib; {
    description = "Configurable set of panels that display various debug information";
    homepage = https://github.com/jazzband/django-debug-toolbar;
    maintainers = with maintainers; [ peterromfeldhk ];
    # license = with licenses; [ ??? ]; # not sure what license that is
  };
}
