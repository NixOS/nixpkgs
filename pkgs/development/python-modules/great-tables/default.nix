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
  shiny,
  syrupy,
}:

buildPythonPackage rec {
  pname = "great-tables";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "great-tables";
    rev = "refs/tags/v${version}";
    hash = "sha256-+n8s8cmsQizEUuRGzFrOxhWL0C9OQO506msiHD58jGQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    babel
    commonmark
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
    shiny
    syrupy
  ];

  disabledTests = [
    # require selenium with chrome driver:
    "test_save_image_file"
    "test_save_non_png"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Library for rendering and formatting dataframes";
    homepage = "https://github.com/posit-dev/great-tables";
    changelog = "https://github.com/posit-dev/great-tables/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
