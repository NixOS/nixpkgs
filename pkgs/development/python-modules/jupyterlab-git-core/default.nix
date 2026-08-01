{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  nodejs,
  writableTmpDirAsHomeHook,
  yarn-berry_3,
  anyio,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,
  nbdime,
  nbformat,
  packaging,
  pexpect,
  pytest-asyncio,
  pytestCheckHook,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyterlab-git-core";
  version = "0.54.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab-git";
    tag = "v${version}";
    hash = "sha256-oTXvugfBay2cmRDu4yo6eFm3qGal3wgxc83dFeKs5Gw=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src;
    hash = "sha256-gJvrR/4Ov9jHjhPtlqYe9ZfMYOd2WtGQdbDGv/JikJA=";
  };

  preBuild = ''
    cd packages/core
  '';

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

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

    # Upstream's Core tests import the sibling server package from the workspace.
    export PYTHONPATH="$PWD/../jupyterlab''${PYTHONPATH:+:$PYTHONPATH}"
  '';

  pytestFlags = [ "--confcutdir=." ];

  pythonImportsCheck = [ "jupyterlab_git_core" ];

  meta = {
    description = "Core package for the JupyterLab Git extension";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}
