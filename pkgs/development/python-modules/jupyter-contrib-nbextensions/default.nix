{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipython-genutils,
  jupyter-contrib-core,
  jupyter-highlight-selected-word,
  jupyter-nbextensions-configurator,
  lxml,
  nose,
  pytestCheckHook,
  notebook,
}:

buildPythonPackage rec {
  pname = "jupyter-contrib-nbextensions";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ipython-contrib";
    repo = "jupyter_contrib_nbextensions";
    rev = "refs/tags/${version}";
    hash = "sha256-1o8tBfRw6jNcKfNE7xXrQaEhx+KOv7mLOruvuMDtJ1Q=";
  };

  propagatedBuildInputs = [
    ipython-genutils
    jupyter-contrib-core
    jupyter-highlight-selected-word
    jupyter-nbextensions-configurator
    lxml
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Thoses tests fail upstream because of nbconvert being too recent
    # https://github.com/ipython-contrib/jupyter_contrib_nbextensions/issues/1606
    "tests/test_exporters.py"

    # Requires to run jupyter which is not feasible here
    "tests/test_application.py"
  ];

  pythonImportsCheck = [ "jupyter_contrib_nbextensions" ];

  meta = with lib; {
    description = "A collection of various notebook extensions for Jupyter";
    homepage = "https://github.com/ipython-contrib/jupyter_contrib_nbextensions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
    # https://github.com/ipython-contrib/jupyter_contrib_nbextensions/issues/1647
    broken = versionAtLeast notebook.version "7";
  };
}
