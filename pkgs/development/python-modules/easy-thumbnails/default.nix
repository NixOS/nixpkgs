{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  fetchpatch,
  pillow,
  reportlab,
  svglib,
  pytestCheckHook,
  pytest-django,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "easy-thumbnails";
  version = "2.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "easy-thumbnails";
    tag = version;
    hash = "sha256-GPZ99OaQRSogS8gJXz8rVUjUeNkEk019TYx0VWa0Q6I=";
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
  ];

  optional-dependencies.svg = [
    reportlab
    svglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
    changelog = "https://github.com/SmileyChris/easy-thumbnails/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
