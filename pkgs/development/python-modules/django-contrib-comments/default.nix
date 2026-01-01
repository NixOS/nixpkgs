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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "Code formerly known as django.contrib.comments";
    license = lib.licenses.bsd0;
=======
  meta = with lib; {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "Code formerly known as django.contrib.comments";
    license = licenses.bsd0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
