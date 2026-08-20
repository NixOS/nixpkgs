{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  bleach,
  jupytext,
  kagglesdk,
  packaging,
  protobuf,
  python-dateutil,
  python-dotenv,
  python-slugify,
  requests,
  six,
  tqdm,
  urllib3,

  # tests
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kaggle";
  version = "2.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kaggle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G/9Z6sLapCoM1LLavn/y3jAsJeOBLnf7xL1ffixazPM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleach
    jupytext
    kagglesdk
    packaging
    protobuf
    python-dateutil
    python-dotenv
    python-slugify
    requests
    six
    tqdm
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
    # kaggle creates its config dir at import time; needs a writable HOME.
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/var/empty/.kaggle'
    "HOME"
  ];

  # kaggle authenticates at import time; fake creds for the offline checks.
  env = {
    KAGGLE_USERNAME = "nixos-test";
    KAGGLE_KEY = "00000000000000000000000000000000";
  };

  pythonImportsCheck = [ "kaggle" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Official Kaggle CLI";
    mainProgram = "kaggle";
    homepage = "https://github.com/Kaggle/kaggle-cli";
    changelog = "https://github.com/Kaggle/kaggle-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
})
