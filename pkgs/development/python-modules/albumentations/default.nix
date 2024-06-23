{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deepdiff,
  numpy,
  opencv4,
  pyyaml,
  scikit-image,
  scikit-learn,
  scipy,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  torch,
  torchvision,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.4.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albumentations-team";
    repo = "albumentations";
    rev = "refs/tags/${version}";
    hash = "sha256-tzalxhn61hYI6lN1wXwOd1EhTPx/9Fk8pTn/+zx188Y=";
  };


  pythonRemoveDeps = [
    "opencv-python"
    "pydantic"
  ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opencv4
    pydantic
    pyyaml
    scikit-image
    scikit-learn
    scipy
    typing-extensions
  ];

  nativeCheckInputs = [
    deepdiff
    pytestCheckHook
    torch
    torchvision
  ];

  disabledTests = [
    # this test hangs up
    "test_transforms"
  ];

  pythonImportsCheck = [ "albumentations" ];

  meta = with lib; {
    description = "Fast image augmentation library and easy to use wrapper around other libraries";
    homepage = "https://github.com/albumentations-team/albumentations";
    changelog = "https://github.com/albumentations-team/albumentations/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
