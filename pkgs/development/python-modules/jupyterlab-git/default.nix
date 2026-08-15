{
  lib,
  buildPythonPackage,
  gitMinimal,
  writableTmpDirAsHomeHook,
  hatch-nodejs-version,
  hatchling,
  jupyterlab-git-core,
  jupyter-server,
  jupytext,
  nbdime,
  pytest-asyncio,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyterlab-git";
  inherit (jupyterlab-git-core) src version;
  pyproject = true;

  preBuild = ''
    cd packages/jupyterlab
  '';

  build-system = [
    hatch-nodejs-version
    hatchling
  ];

  dependencies = [
    jupyterlab-git-core
    jupyter-server
    nbdime
    traitlets
  ];

  nativeCheckInputs = [
    gitMinimal
    jupytext
    pytest-asyncio
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "jupyterlab_git" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}
