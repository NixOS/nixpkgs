{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytest-django,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-treebeard";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-treebeard";
    repo = "django-treebeard";
    tag = finalAttrs.version;
    hash = "sha256-m/KCZRuUDfhhEq7g8ziCa1pvRkYVdu5xMKbGWBalKP4=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "treebeard" ];

  meta = {
    description = "Efficient tree implementations for Django";
    homepage = "https://tabo.pe/projects/django-treebeard/";
    changelog = "https://github.com/django-treebeard/django-treebeard/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.asl20;
  };
})
