{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  nodejs,
  yarn-berry_3,

  # build-system
  hatch-jupyter-builder,
  hatchling,
  jupyterlab,

  # dependencies
  markdown-it-py,
  mdit-py-plugins,
  nbformat,
  packaging,
  pyyaml,

  # tests
  addBinToPathHook,
  jupyter-client,
  notebook,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupytext";
  version = "1.19.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = "jupytext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5NTp94JhUHdbWGh53cQ594I1zcPh4GpqLSJP5TjIhFI=";
  };

  postPatch = ''
    substituteInPlace tests/functional/contents_manager/test_async_and_sync_contents_manager_are_in_sync.py \
      --replace-fail "from black import FileMode, format_str" "" \
      --replace-fail "format_str(sync_code, mode=FileMode())" "sync_code"
  '';

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  # To generate:
  # nix-shell -p yarn-berry_3.yarn-berry-fetcher --command \
  #   "yarn-berry-fetcher missing-hashes "$(nix-build -A python3Packages.jupytext.src)/jupyterlab/yarn.lock" > pkgs/development/python-modules/jupytext/missing-hashes.json"
  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    sourceRoot = "${finalAttrs.src.name}/jupyterlab";
    hash = "sha256-gfNrPOcT7M7QYQkv8tD/F1tOkvsRu/0HPzn/QUzVK+4=";
  };

  env.HATCH_BUILD_HOOKS_ENABLE = true;

  preConfigure = ''
    pushd jupyterlab
  '';

  preBuild = ''
    popd
  '';

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  dependencies = [
    markdown-it-py
    mdit-py-plugins
    nbformat
    packaging
    pyyaml
  ];

  nativeCheckInputs = [
    addBinToPathHook
    jupyter-client
    notebook
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    versionCheckHook
    # Tests that use a Jupyter notebook require $HOME to be writable
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Requires the `git` python module
    "tests/external"
  ];

  disabledTests = [
    # Fails due to whitespace differences in the outputs
    "test_async_and_sync_files_are_in_sync"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # requires access to trash
    "test_load_save_rename"
  ];

  pythonImportsCheck = [
    "jupytext"
    "jupytext.cli"
  ];

  meta = {
    description = "Jupyter notebooks as Markdown documents, Julia, Python or R scripts";
    homepage = "https://github.com/mwouts/jupytext";
    changelog = "https://github.com/mwouts/jupytext/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupytext";
  };
})
