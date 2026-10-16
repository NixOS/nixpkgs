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
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-treebeard";
    repo = "django-treebeard";
    tag = finalAttrs.version;
    hash = "sha256-GvW5QjCuour56NhAt2o2eQ6g2UoXZnukXGVWop1tjSk=";
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
    changelog = "https://github.com/django-treebeard/django-treebeard/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.asl20;
  };
})
