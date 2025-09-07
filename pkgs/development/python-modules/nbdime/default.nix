{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-jupyter-builder,
  hatchling,
  jupyterlab,

  # dependencies
  colorama,
  gitpython,
  jinja2,
  jupyter-server,
  jupyter-server-mathjax,
  nbformat,
  pygments,
  requests,
  tornado,

  # tests
  gitMinimal,
  pytest-tornado,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "nbdime";
  version = "4.0.2";
  pyproject = true;

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
    colorama
    gitpython
    jinja2
    jupyter-server
    jupyter-server-mathjax
    nbformat
    pygments
    requests
    tornado
  ];

  nativeCheckInputs = [
    gitMinimal
    pytest-tornado
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # subprocess.CalledProcessError: Command '['git', 'diff', 'base', 'diff.ipynb']' returned non-zero exit status 128.
    # git-nbdiffdriver diff: line 1: git-nbdiffdriver: command not found
    # fatal: external diff died, stopping at diff.ipynb
    "test_git_diffdriver"

    # subprocess.CalledProcessError: Command '['git', 'merge', 'remote-no-conflict']' returned non-zero exit status 1.
    "test_git_mergedriver"

    # Require network access
    "test_git_difftool"
    "test_git_mergetool"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: Could not find system gitattributes location!
    "test_locate_gitattributes_syste"
  ];

  preCheck = ''
    git config --global user.email "janedoe@example.com"
    git config --global user.name "Jane Doe"
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "nbdime" ];

  meta = {
    homepage = "https://github.com/jupyter/nbdime";
    changelog = "https://github.com/jupyter/nbdime/blob/${version}/CHANGELOG.md";
    description = "Tools for diffing and merging of Jupyter notebooks";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
