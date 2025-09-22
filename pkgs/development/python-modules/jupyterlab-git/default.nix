{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  gitMinimal,
  nodejs,
  writableTmpDirAsHomeHook,
  yarn-berry_3,
  jupyter-server,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,
  nbdime,
  nbformat,
  packaging,
  pexpect,
  pytest-asyncio,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyterlab-git";
  version = "0.51.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab-git";
    tag = "v${version}";
    hash = "sha256-YQWS+/GfQzkQ/n0xBq+K8lJ9tjvIRJxa3w3AzNARpDo=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src;
    hash = "sha256-9GmQv4UYH+uRPgAZed6IJC+7uMKhlXvokVwd248yi/4=";
  };

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  dependencies = [
    jupyter-server
    nbdime
    nbformat
    packaging
    pexpect
    traitlets
  ];

  propagatedBuildInputs = [ git ];

  nativeCheckInputs = [
    gitMinimal
    pytest-asyncio
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "jupyterlab_git/tests/test_handlers.py"
  ];

  disabledTests = [
    "test_Git_get_nbdiff_file"
    "test_Git_get_nbdiff_dict"
  ];

  pythonImportsCheck = [ "jupyterlab_git" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ chiroptical ];
  };
}
