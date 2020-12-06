{ lib, buildPythonPackage, fetchPypi, callPackage, isPy3k
, hypothesis
, setuptools_scm
, six
, attrs
, py
, setuptools
, pytestcov
, pytest-timeout
, pytest-tornado
, mock
, tabulate
, nbformat
, jsonschema
, pytest
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
    pytestcov
    pytest-timeout
    pytest-tornado
    jsonschema
    mock
    tabulate
    pytest
  ];

  nativeBuildInputs = [ setuptools_scm ];

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
