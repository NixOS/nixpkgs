{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  albucore,
  eval-type-backport,
  numpy,
  opencv4,
  pydantic,
  pyyaml,
  scikit-image,
  scipy,

  # optional dependencies
  huggingface-hub,
  pillow,

  # tests
  deepdiff,
  pytestCheckHook,
  pytest-mock,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.4.20";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albumentations";
    rev = "refs/tags/${version}";
    hash = "sha256-lyYbkO2J3kpZGk8Q3FYfRiQh+BdolCfeEcjlI3W/rIw=";
  };

  patches = [
    ./dont-check-for-updates.patch
  ];

  pythonRemoveDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  dependencies = [
    albucore
    eval-type-backport
    numpy
    opencv4
    pydantic
    pyyaml
    scikit-image
    scipy
  ];

  optional-dependencies = {
    hub = [ huggingface-hub ];
    text = [ pillow ];
  };

  nativeCheckInputs = [
    deepdiff
    pytestCheckHook
    pytest-mock
    torch
    torchvision
  ];

  disabledTests = [
    "test_pca_inverse_transform"
    # this test hangs up
    "test_transforms"
  ];

  pythonImportsCheck = [ "albumentations" ];

  meta = {
    description = "Fast image augmentation library and easy to use wrapper around other libraries";
    homepage = "https://github.com/albumentations-team/albumentations";
    changelog = "https://github.com/albumentations-team/albumentations/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
