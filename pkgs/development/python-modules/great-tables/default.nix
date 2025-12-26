{
  lib,
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

buildPythonPackage rec {
  pname = "great-tables";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "great-tables";
    tag = "v${version}";
    hash = "sha256-3SyY3mI5fd0S5pi1vG+BQaWHv/qB2L6vlIXxjO4UO1E=";
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
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Library for rendering and formatting dataframes";
    homepage = "https://github.com/posit-dev/great-tables";
    changelog = "https://github.com/posit-dev/great-tables/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
