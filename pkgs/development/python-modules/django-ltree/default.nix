{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-ltree";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mariocesar";
    repo = "django-ltree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XN2znH9bNU8jaY2HC8qmSR6VqShcEFGAtNtb/5aLgic=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "django_ltree"
  ];

  meta = {
    description = "An ltree extension implementation to support hierarchical tree-like data using the native Postgres extension ltree in django models";
    homepage = "https://github.com/mariocesar/django-ltree";
    changelog = "https://github.com/mariocesar/django-ltree/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
})
