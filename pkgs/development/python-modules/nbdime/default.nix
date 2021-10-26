{ lib, buildPythonPackage, fetchPypi, isPy3k
, hypothesis
, setuptools-scm
, six
, attrs
, py
, setuptools
, pytest-cov
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
, GitPython
, jupyter-server-mathjax
, notebook
, jinja2
}:

buildPythonPackage rec {
  pname = "nbdime";
  version = "3.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "12dc4390b355b26d07ac8d11d50efbcb54bae0ad5842b817131babd2f4567963";
  };

  checkInputs = [
    hypothesis
    pytest-cov
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
    "test_inline_merge"
    "test_interrogate_filter_no_repo"
    "test_merge"
  ];

  nativeBuildInputs = [ setuptools-scm ];

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
    GitPython
    notebook
    jinja2
    ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbdime";
    description = "Tools for diffing and merging of Jupyter notebooks.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tbenst ];
  };
}
