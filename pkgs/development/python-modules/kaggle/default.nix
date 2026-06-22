{
  bleach,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jupytext,
  kagglesdk,
  lib,
  packaging,
  protobuf,
  python-dateutil,
  python-dotenv,
  python-slugify,
  pytestCheckHook,
  requests,
  six,
  tqdm,
  urllib3,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "kaggle";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kaggle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LPeJxjxyeRHElU4y1JiG0zTX5NFlrrnwP6ZYdYkR8mo=";
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
    # kaggle creates its config dir at import time; needs a writable HOME.
    writableTmpDirAsHomeHook
  ];

  # kaggle authenticates at import time; fake creds for the offline checks.
  env = {
    KAGGLE_USERNAME = "nixos-test";
    KAGGLE_KEY = "00000000000000000000000000000000";
  };

  pythonImportsCheck = [ "kaggle" ];

  meta = {
    description = "Official Kaggle CLI";
    mainProgram = "kaggle";
    homepage = "https://github.com/Kaggle/kaggle-cli";
    changelog = "https://github.com/Kaggle/kaggle-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
})
