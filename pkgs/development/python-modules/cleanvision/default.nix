{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  fsspec,
  imagehash,
  matplotlib,
  numpy,
  pandas,
  pillow,
  tabulate,
  tqdm,

  # tests
  datasets,
  psutil,
  pytestCheckHook,
  torchvision,
}:

buildPythonPackage rec {
  pname = "cleanvision";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cleanlab";
    repo = "cleanvision";
    rev = "refs/tags/v${version}";
    hash = "sha256-QAydDqLJx/jYKXqxRUElTdM5dOFA6nZag8rNAjPZjRg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fsspec
    imagehash
    matplotlib
    numpy
    pandas
    pillow
    tabulate
    tqdm
  ];

  pythonImportsCheck = [ "cleanvision" ];

  nativeCheckInputs = [
    datasets
    psutil
    pytestCheckHook
    torchvision
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Requires accessing s3 (online)
    "test_s3_dataset"
  ];

  meta = {
    description = "Automatically find issues in image datasets and practice data-centric computer vision";
    homepage = "https://github.com/cleanlab/cleanvision";
    changelog = "https://github.com/cleanlab/cleanvision/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # Fatal Python error: Aborted
    broken = stdenv.isDarwin;
  };
}
