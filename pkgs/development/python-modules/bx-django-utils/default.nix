{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
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

buildPythonPackage rec {
  pname = "bx-django-utils";
  version = "81";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "bx_django_utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-xXiyPBzsvzrKbLcRVVNLNhVSuEJx1Ek0w4X3z2BMnDI=";
  };

  postPatch = ''
    substituteInPlace bx_django_utils_tests/tests/test_translation.py \
      --replace-fail "assertQuerysetEqual" "assertQuerySetEqual"
  '';

  build-system = [
    setuptools-scm
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
    # playwright._impl._errors.Error: It looks like you are using Playwright Sync API inside the asyncio loop.
    # Please use the Async API instead.
    "bx_django_utils_tests/tests/test_playwright_helper.py"
    "bx_django_utils_tests/tests/test_user_timezone/test_admin.py"
    # No need to test meta things such as project setup and the readme
    "bx_django_utils_tests/tests/test_project_setup.py"
    "bx_django_utils_tests/tests/test_readme.py"

    "bx_django_utils_tests/tests/test_doctests.py"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="bx_django_utils_tests.test_project.settings"
    export SKIP_TEST_MIGRATION=true
  '';

  pythonImportsCheck = [ "bx_django_utils" ];

  meta = {
    description = "Various Django utility functions";
    homepage = "https://github.com/boxine/bx_django_utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
