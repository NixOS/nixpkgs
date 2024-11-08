{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SN4A8VZ34BaiFq7/IF1uAOQ5HJpXAhNsZBGcRytzVto=";
  };

  propagatedBuildInputs = [ django ];

  meta = with lib; {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "Code formerly known as django.contrib.comments";
    license = licenses.bsd0;
  };
}
