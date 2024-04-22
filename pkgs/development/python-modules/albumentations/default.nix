{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, numpy
, opencv4
, pyyaml
, qudida
, scikit-image
, scipy
, deepdiff
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lznWLJocXdfwnhAZ33V5ZdlFCAsNa0u/rjfkjmHBQOg=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "opencv-python"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    opencv4
    pyyaml
    qudida
    scikit-image
    scipy
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
