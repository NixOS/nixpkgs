{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  nodejs,
  yarn-berry_3,
  distutils,

  # build-system
  hatch-jupyter-builder,
  hatchling,
  jupyter-builder,
  jupyterlab,

  # dependencies
  jupyter-server,
  jupyterlab-server,
  notebook-shim,
  tornado,

  # tests
  pytest-jupyter,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "notebook";
  version = "7.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "notebook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sgIEaEgeaHcl42cVYx2BQuP+66Pc5Fyt8EvOQdtcYE0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "timeout = 300" ""
  '';

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    distutils
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-brU97MOuozhJjg/jPb25wFenTFzJOW8+NLf1VukC5lY=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
    jupyter-builder
    jupyterlab
  ];

  dependencies = [
    jupyter-server
    jupyterlab
    jupyterlab-server
    notebook-shim
    tornado
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
    versionCheckHook
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  env = {
    JUPYTER_PLATFORM_DIRS = 1;
  };

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Web-based notebook environment for interactive computing";
    homepage = "https://github.com/jupyter/notebook";
    changelog = "https://github.com/jupyter/notebook/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-notebook";
  };
})
