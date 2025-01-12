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
  python-poppler,
  zipstream-ng,
  django-json-widget,
  factory-boy,
  pytest-django,
  camelot,
  pytesseract,
  pytest-factoryboy,
  poppler_utils,
  pytest-playwright,
  playwright-driver,
  pnpm,
  nodejs,
}:

buildPythonPackage rec {
  pname = "django-filingcabinet";
  version = "0-unstable-2024-11-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "django-filingcabinet";
    # No release tagged yet on GitHub
    # https://github.com/okfde/django-filingcabinet/issues/69
    rev = "33c88e1ca9fccd0ea70f8b609580eeec486bda5c";
    hash = "sha256-p7VJUiO7dhTR+S3/4QrmrQeJO6xGj7D7I8W3CBF+jo8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "zipstream" "zipstream-ng"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  dependencies = [
    celery
    django
    django-filter
    django-json-widget
    django-taggit
    django-treebeard
    djangorestframework
    feedgen
    jsonschema
    pikepdf
    pycryptodome
    pypdf
    python-poppler
    reportlab
    wand
    zipstream-ng
  ];

  optional-dependencies = {
    tabledetection = [ camelot ];
    ocr = [ pytesseract ];
    # Dependencies not yet packaged
    #webp = [ webp ];
    #annotate = [ fcdocs-annotate ];
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-32kOhB2+37DD4hKXKep08iDxhXpasKPfcv9fkwISxeU=";
  };

  postBuild = ''
    pnpm run build
  '';

  postInstall = ''
    cp -r build $out/
  '';

  nativeCheckInputs = [
    poppler_utils
    pytest-django
    pytest-factoryboy
    pytest-playwright
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Locator expected to be visible
    "test_keyboard_scroll"
    "test_number_input_scroll"
    # playwright._impl._errors.TimeoutError: Locator.click: Timeout 30000ms exceeded
    "test_sidebar_hide"
    "test_show_search_bar"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="test_project.settings"
    export PLAYWRIGHT_BROWSERS_PATH="${playwright-driver.browsers}"
  '';

  pythonImportsCheck = [ "filingcabinet" ];

  meta = {
    description = "Django app that manages documents with pages, annotations and collections";
    homepage = "https://github.com/okfde/django-filingcabinet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
