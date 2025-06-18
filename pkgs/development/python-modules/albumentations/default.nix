{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  albucore,
  numpy,
  opencv-python,
  pydantic,
  pyyaml,
  scipy,

  # optional dependencies
  huggingface-hub,
  pillow,
  torch,

  # tests
  deepdiff,
  pytestCheckHook,
  pytest-mock,
  scikit-image,
  scikit-learn,
  torchvision,
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "2.0.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albumentations";
    tag = version;
    hash = "sha256-8vUipdkIelRtKwMw63oUBDN/GUI0gegMGQaqDyXAOTQ=";
  };

  patches = [
    ./dont-check-for-updates.patch
  ];

  pythonRelaxDeps = [ "opencv-python" ];

  build-system = [ setuptools ];

  dependencies = [
    albucore
    numpy
    opencv-python
    pydantic
    pyyaml
    scipy
  ];

  optional-dependencies = {
    hub = [ huggingface-hub ];
    pytorch = [ torch ];
    text = [ pillow ];
  };

  nativeCheckInputs = [
    deepdiff
    pytestCheckHook
    pytest-mock
    scikit-image
    scikit-learn
    torch
    torchvision
  ];

  disabledTests = [
    "test_pca_inverse_transform"
    # these tests hang
    "test_keypoint_remap_methods"
    "test_multiprocessing_support"
  ];

  pythonImportsCheck = [ "albumentations" ];

  meta = {
    description = "Fast image augmentation library and easy to use wrapper around other libraries";
    homepage = "https://github.com/albumentations-team/albumentations";
    changelog = "https://github.com/albumentations-team/albumentations/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
