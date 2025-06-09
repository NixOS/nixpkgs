{
  stdenv,
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
  poppler-utils,
  pytest-playwright,
  playwright-driver,
  pnpm,
  nodejs,
  markdown,
  nh3,
}:

buildPythonPackage rec {
  pname = "django-filingcabinet";
  version = "0.17-unstable-2025-04-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "okfde";
    repo = "django-filingcabinet";
    # No release tagged yet on GitHub
    # https://github.com/okfde/django-filingcabinet/issues/69
    rev = "64b7b4ad804067e2f16e8a0f165c139e3ffe5fb5";
    hash = "sha256-48Peui/5N/GfzWS1EJ5uKeKEoPjX+fPEXzG2owxsDaE=";
  };

  postPatch = ''
    # zipstream is discontinued and outdated
    # https://github.com/okfde/django-filingcabinet/issues/90
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
    markdown
    nh3
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
    hash = "sha256-uMO2iEOi9ACYdIM8Thf7+y1KpHQEqVxO3yxZ8RaGFXA=";
  };

  postBuild = ''
    pnpm run build
  '';

  postInstall = ''
    cp -r build $out/
  '';

  nativeCheckInputs = [
    poppler-utils
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
    # Unable to launch browser
    "test_document_viewer"
  ];

  preCheck =
    ''
      export DJANGO_SETTINGS_MODULE="test_project.settings"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isRiscV) ''
      export PLAYWRIGHT_BROWSERS_PATH="${playwright-driver.browsers}"
    '';

  pythonImportsCheck = [ "filingcabinet" ];

  # Playwright tests not supported on RiscV yet
  doCheck = lib.meta.availableOn stdenv.hostPlatform playwright-driver.browsers;

  meta = {
    description = "Django app that manages documents with pages, annotations and collections";
    homepage = "https://github.com/okfde/django-filingcabinet";
    changelog = "https://github.com/feincms/django-cabinet/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
