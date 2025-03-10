{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  html5lib,
  pillow,
  django-cms,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "djangocms-text-ckeditor";
  version = "5.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "djangocms_text_ckeditor";
    hash = "sha256-ow2S4FJkO037QUkAf3FheVl2O4BaLw1PSSCVRBhlRX0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django-cms
    html5lib
    pillow
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="tests.settings"
  '';

  # Tests require module "djangocms-helper" which is not yet packaged
  doCheck = false;

  pythonImportsCheck = [ "djangocms_text_ckeditor" ];

  meta = {
    description = "Text Plugin for django CMS using CKEditor 4";
    homepage = "https://github.com/django-cms/djangocms-text-ckeditor";
    changelog = "https://github.com/django-cms/djangocms-text-ckeditor/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
