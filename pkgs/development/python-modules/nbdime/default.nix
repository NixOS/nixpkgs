{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hatch-jupyter-builder,
  hatchling,
  jupyterlab,
  nbformat,
  colorama,
  pygments,
  tornado,
  requests,
  gitpython,
  jupyter-server,
  jupyter-server-mathjax,
  jinja2,
  git,
  pytest-tornado,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nbdime";
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2Cefj0sjbAslOyDWDEgxu2eEPtjb1uCfI06wEdNvG/I=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  dependencies = [
    nbformat
    colorama
    pygments
    tornado
    requests
    gitpython
    jupyter-server
    jupyter-server-mathjax
    jinja2
  ];

  nativeCheckInputs = [
    git
    pytest-tornado
    pytestCheckHook
  ];

  disabledTests = [
    "test_git_diffdriver"
    "test_git_difftool"
    "test_git_mergedriver"
    "test_git_mergetool"
  ];

  preCheck = ''
    export HOME="$TEMP"
    git config --global user.email "janedoe@example.com"
    git config --global user.name "Jane Doe"
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "nbdime" ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbdime";
    changelog = "https://github.com/jupyter/nbdime/blob/${version}/CHANGELOG.md";
    description = "Tools for diffing and merging of Jupyter notebooks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tbenst ];
  };
}
