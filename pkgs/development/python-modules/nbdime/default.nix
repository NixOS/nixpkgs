{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hypothesis
, setuptools-scm
, six
, attrs
, py
, setuptools
, pytest-timeout
, pytest-tornado
, mock
, tabulate
, nbformat
, jsonschema
, pytestCheckHook
, colorama
, pygments
, tornado
, requests
, gitpython
, jupyter-server
, jupyter-server-mathjax
, notebook
, jinja2
}:

buildPythonPackage rec {
  pname = "nbdime";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MUCaMPhI/8azJUBpfoLVoKG4TcwycWynTni8xLRXxFM=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    py
    setuptools
    six
    jupyter-server-mathjax
    nbformat
    colorama
    pygments
    tornado
    requests
    gitpython
    notebook
    jinja2
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-timeout
    pytest-tornado
    jsonschema
    mock
    tabulate
    pytestCheckHook
  ];

  disabledTests = [
    "test_apply_filter_no_repo"
    "test_diff_api_checkpoint"
    "test_filter_cmd_invalid_filter"
    "test_inline_merge_source_add"
    "test_inline_merge_source_patches"
    "test_inline_merge_source_replace"
    "test_inline_merge_cells_insertion"
    "test_inline_merge_cells_replacement"
    "test_interrogate_filter_no_repo"
    "test_merge_input_strategy_inline"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "nbdime"
  ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbdime";
    description = "Tools for diffing and merging of Jupyter notebooks.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tbenst ];
  };
}
