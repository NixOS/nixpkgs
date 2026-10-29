{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  django,
  python,
}:

buildPythonPackage rec {
  pname = "django-contrib-comments";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SN4A8VZ34BaiFq7/IF1uAOQ5HJpXAhNsZBGcRytzVto=";
  };

  patches = [
    (fetchpatch {
      name = "fix-django-issues.patch";
      url = "https://github.com/django/django-contrib-comments/commit/36bd49060c58eb96e12e42eb098eb63ccaae848e.patch?full_index=1";
      hash = "sha256-Rs1Vzv+/SLiptrezfYYmCdWLbFVh4s5rsgKJBgq+WHk=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ django ];

  checkPhase = ''
    ${python.interpreter} tests/runtests.py
  '';

  meta = {
    homepage = "https://github.com/django/django-contrib-comments";
    description = "Code formerly known as django.contrib.comments";
    license = lib.licenses.bsd3;
  };
}
