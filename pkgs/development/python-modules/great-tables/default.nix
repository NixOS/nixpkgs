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
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "great-tables";
    tag = "v${version}";
    hash = "sha256-68Fx1BNDl5/nATR7CnKgd46qWCW5Rbur8YRACzN5iUU=";
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
    changelog = "https://github.com/posit-dev/great-tables/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
