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
  pythonOlder,
  tomli,

  # tests
  jupyter-client,
  notebook,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "jupytext";
  version = "1.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwouts";
    repo = "jupytext";
    tag = "v${version}";
    hash = "sha256-xMmtppXect+PRlEp2g0kJurALVvcfza+FBbZbK2SbHc=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src missingHashes;
    sourceRoot = "${src.name}/jupyterlab";
    hash = "sha256-UOsQsvnPpwpiKilaS0Rs/j1YReDljpLbEWZaeoRVK9g=";
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    jupyter-client
    notebook
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  preCheck = ''
    # Tests that use a Jupyter notebook require $HOME to be writable
    export HOME=$(mktemp -d);
    export PATH=$out/bin:$PATH;

    substituteInPlace tests/functional/contents_manager/test_async_and_sync_contents_manager_are_in_sync.py \
      --replace-fail "from black import FileMode, format_str" "" \
      --replace-fail "format_str(sync_code, mode=FileMode())" "sync_code"
  '';

  disabledTestPaths = [
    # Requires the `git` python module
    "tests/external"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
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
    changelog = "https://github.com/mwouts/jupytext/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupytext";
  };
}
