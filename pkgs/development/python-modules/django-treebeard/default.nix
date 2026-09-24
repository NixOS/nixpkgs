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
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-treebeard";
    repo = "django-treebeard";
    tag = finalAttrs.version;
    hash = "sha256-L2Dodci3aBUw432V30gjut/P4Gy9l0VEZpRizVSNILI=";
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
