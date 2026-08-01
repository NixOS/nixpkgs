{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.52.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "jupyterlab-git";
    tag = "v${version}";
    hash = "sha256-BMzn+134hSYUFrDF+4+Bs81hzSURP9VNX4D9x2UuPMQ=";
  };

  # Remove both patches when updating to 0.54.0 or later.
  patches = [
    (fetchpatch2 {
      name = "CVE-2026-54527.patch";
      url = "https://github.com/jupyterlab/jupyterlab-git/commit/c6d37b88f36aa59aee317930b95e427fb9d6b09b.patch?full_index=1";
      hash = "sha256-eWE8TVetOyMWAlgjuNL03yxGoPMke+rGiU2H3qSBzM0=";
    })
    # Adapted from upstream commit 460035275b5963dc96e364e60ba6a73717fbd033
    # to the pre-workspace 0.52.0 source layout.
    ./CVE-2026-54528.patch
  ];

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src;
    hash = "sha256-3pVc4xz5ilamCg97wdaLQliBHeSr3mPYwhgnz/lvfj0=";
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

  preCheck = ''
    jlpm test --runInBand \
      src/__tests__/test-components/NotebookDiff.spec.tsx \
      src/__tests__/test-components/PlainTextDiff.spec.tsx
    pytest jupyterlab_git/tests/test_handlers.py \
      -k test_git_show_prefix_for_excluded_path
  '';

  pythonImportsCheck = [ "jupyterlab_git" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jupyter lab extension for version control with Git";
    homepage = "https://github.com/jupyterlab/jupyterlab-git";
    changelog = "https://github.com/jupyterlab/jupyterlab-git/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}
