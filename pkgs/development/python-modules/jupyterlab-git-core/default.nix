{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,

  # nativeBuildInputs
  nodejs,
  yarn-berry_3,

  # dependencies
  anyio,
  nbformat,
  packaging,
  pexpect,
  traitlets,

  # propagatedBuildInputs
  git,

  # tests
  nbdime,
  pytest-asyncio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyterlab-git-core";
  version = "0.54.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab-git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-huVsVpMgsSrrIvsu4dvmbOoRxGDlM2rkBy6hsZSw1as=";
  };

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-+Dz3qQcSYDiuFsOKbmRmdFE4LCGXVL4jkusH+IfU28E=";
  };

  preBuild = ''
    cd packages/core
  '';

  dependencies = [
    anyio
    nbformat
    packaging
    pexpect
    traitlets
  ];

  propagatedBuildInputs = [ git ];

  nativeCheckInputs = [
    nbdime
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    (
      cd ../..
      jlpm test --runInBand \
        src/__tests__/test-components/NotebookDiff.spec.tsx \
        src/__tests__/test-components/PlainTextDiff.spec.tsx
    )
  ''
  # Upstream's Core tests import the sibling server package from the workspace.
  + ''
    export PYTHONPATH="$PWD/../jupyterlab''${PYTHONPATH:+:$PYTHONPATH}"
  '';

  pytestFlags = [ "--confcutdir=." ];

  pythonImportsCheck = [ "jupyterlab_git_core" ];

  meta = {
    description = "Core package for the JupyterLab Git extension";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chiroptical ];
  };
})
