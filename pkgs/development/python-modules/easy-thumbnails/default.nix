{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pillow,
  pythonOlder,
  reportlab,
  svglib,
  pytestCheckHook,
  pytest-django,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "easy-thumbnails";
    rev = "refs/tags/${version}";
    hash = "sha256-8JTHYQIBbu/4fknK2ZEQeDSgaxKGDfflxumcFMpaGQk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pillow
    reportlab
    svglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  checkInputs = [ testfixtures ];

  disabledTests = [
    # AssertionError: 'ERROR' != 'INFO'
    "test_postprocessor"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="easy_thumbnails.tests.settings"
  '';

  pythonImportsCheck = [ "easy_thumbnails" ];

  meta = {
    description = "Easy thumbnails for Django";
    homepage = "https://github.com/SmileyChris/easy-thumbnails";
    changelog = "https://github.com/SmileyChris/easy-thumbnails/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
