{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  python-stdnum,
  bx-py-utils,
  pytestCheckHook,
  pytest-django,
  model-bakery,
  typeguard,
  playwright,
  django-debug-toolbar,
  django-polymorphic,
  lxml,
  beautifulsoup4,
}:

buildPythonPackage (finalAttrs: {
  pname = "bx-django-utils";
  version = "97";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "bx_django_utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S8cSwuZhZlaocPf73F4Pdhlk3wvgaBo/THZipE4rPWY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    python-stdnum
    bx-py-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    model-bakery
    typeguard
    playwright
    django-debug-toolbar
    django-polymorphic
    lxml
    beautifulsoup4
  ];

  disabledTestPaths = [
    # playwright._impl._errors.Error: Playwright Sync API cannot be used inside asyncio loop
    "bx_django_utils_tests/tests/test_playwright_helper.py"
    "bx_django_utils_tests/tests/test_user_timezone/test_admin.py"
    # Project metadata tests check GitHub state, not useful in Nix sandbox
    "bx_django_utils_tests/tests/test_project_setup.py"
    "bx_django_utils_tests/tests/test_readme.py"
    "bx_django_utils_tests/tests/test_doctests.py"
  ];

  env = {
    DJANGO_SETTINGS_MODULE = "bx_django_utils_tests.test_project.settings";
    SKIP_TEST_MIGRATION = "true";
  };

  pythonImportsCheck = [ "bx_django_utils" ];

  meta = {
    description = "Various Django utility functions";
    homepage = "https://github.com/boxine/bx_django_utils";
    changelog = "https://github.com/boxine/bx_django_utils/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
