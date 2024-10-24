{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  setuptools,
  celery,
  django-taggit,
  feedgen,
  reportlab,
  jsonschema,
  wand,
  django-filter,
  django-treebeard,
  djangorestframework,
  pikepdf,
  pypdf,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "django-filingcabinet";
  version = "0-unstable-2024-09-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "django-filingcabinet";
    # No release tagged yet on GitHub
    # https://github.com/okfde/django-filingcabinet/issues/69
    rev = "3b1dc92d89da48af9851e37a22ac1310922b9c73";
    hash = "sha256-Ad2R9Tw6LmwIUMve2pmofKCAbsR/u4Exh92uoztjUaQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    celery
    django
    django-taggit
    feedgen
    reportlab
    jsonschema
    wand
    django-filter
    django-treebeard
    djangorestframework
    pikepdf
    pypdf
    pycryptodome
  ];

  optional-dependencies = {
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "Django app that manages documents with pages, annotations and collections";
    homepage = "https://github.com/okfde/django-filingcabinet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
