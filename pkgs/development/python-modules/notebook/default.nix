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
  jupyterlab,

  # dependencies
  jupyter-server,
  jupyterlab-server,
  notebook-shim,
  tornado,

  # tests
  pytest-jupyter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "notebook";
<<<<<<< HEAD
  version = "7.5.0";
=======
  version = "7.4.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "notebook";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EKfe3uqIwb+kKmSuU7aIinNj1nkRaBvg3liV6RiR3xc=";
=======
    hash = "sha256-bj4iQvm0TGBiCu9drJ8QFXsedzm/cEjevNQS6UsasNs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    inherit src missingHashes;
<<<<<<< HEAD
    hash = "sha256-ILDTRK5NJ33T30YRTT3/g1mIE2sI8spGPwMsWyQ5UTc=";
=======
    hash = "sha256-nRaWzr5Q904KojfK0mPgLX9be82axb8Aab0SJULE7RU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
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
    changelog = "https://github.com/jupyter/notebook/blob/${src.tag}/CHANGELOG.md";
    description = "Web-based notebook environment for interactive computing";
    homepage = "https://github.com/jupyter/notebook";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    mainProgram = "jupyter-notebook";
  };
}
