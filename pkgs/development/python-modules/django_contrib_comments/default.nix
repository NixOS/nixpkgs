{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SN4A8VZ34BaiFq7/IF1uAOQ5HJpXAhNsZBGcRytzVto=";
  };

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "The code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };

}
