{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage {
  pname = "django-ltree";
  version = "unstable-2025-04-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mariocesar";
    repo = "django-ltree";
    rev = "c776e3ba76f1a833c34cbc290978512cea353fd8";
    hash = "sha256-8T0N1PIqw57taA7GxgCSEVtpLQoN/rpa0PirFFdh81c=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  doCheck = false;

  pythonImportsCheck = [
    "django_ltree"
  ];

  meta = {
    description = "An ltree extension implementation to support hierarchical tree-like data using the native Postgres extension ltree in django models";
    homepage = "https://github.com/mariocesar/django-ltree";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
