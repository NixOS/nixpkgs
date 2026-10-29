{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  babel,
  commonmark,
  css-inline,
  faicons,
  htmltools,
  importlib-metadata,
  importlib-resources,
  numpy,
  typing-extensions,

  # tests
  ipykernel,
  ipython,
  pandas,
  polars,
  pyarrow,
  pytestCheckHook,
  pytest-cov-stub,
  requests,
  selenium,
  shiny,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "great-tables";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "great-tables";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d5LKKA6KCkkBGibalWkfOTRzf48YEjdtjCdbGpW2AjE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    babel
    commonmark
    css-inline
    faicons
    htmltools
    importlib-metadata
    importlib-resources
    numpy
    typing-extensions
  ];

  pythonImportsCheck = [ "great_tables" ];

  nativeCheckInputs = [
    ipykernel
    ipython
    pandas
    polars
    pyarrow
    pytestCheckHook
    pytest-cov-stub
    requests
    selenium
    shiny
    syrupy
  ];

  disabledTests = [
    # require selenium with chrome driver:
    "test_save_custom_webdriver"
    "test_save_image_file"
    "test_save_non_png"

    # AssertionError: assert [- snapshot] == [+ received]
    # https://github.com/posit-dev/great-tables/issues/826
    "test_html_string_generated_inline_css"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails due to added newline in HTML output
    # https://github.com/posit-dev/great-tables/issues/826
    "test_html_string_generated_inline_css"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Library for rendering and formatting dataframes";
    homepage = "https://github.com/posit-dev/great-tables";
    changelog = "https://github.com/posit-dev/great-tables/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
