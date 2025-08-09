{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  fetchpatch,
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
    tag = version;
    hash = "sha256-8JTHYQIBbu/4fknK2ZEQeDSgaxKGDfflxumcFMpaGQk=";
  };

  patches = [
    (fetchpatch {
      name = "python313-compat.patch";
      url = "https://github.com/SmileyChris/easy-thumbnails/pull/650.patch";
      hash = "sha256-qD/YnDlDZ7DghLv/mxjQ2o6pSl3fGR+Ipx5NX2BV6zc=";
    })
  ];

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
