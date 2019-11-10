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
  version = "1.0.6";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00nywb69kp9i0wl5mczgwqc5db8v70ihr9cjbwqppd2jkx4vf34j";
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
    homepage = https://github.com/jupyter/nbdime;
    description = "Tools for diffing and merging of Jupyter notebooks.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tbenst ];
  };
}
