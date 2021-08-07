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
, notebook
, jinja2
}:

buildPythonPackage rec {
  pname = "nbdime";
  version = "2.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e3efdcfda31c3074cb565cd8e76e2e5421b1c4560c3a00c56f8679dd15590e5";
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
