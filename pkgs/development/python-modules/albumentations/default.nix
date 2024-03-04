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
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZJ+KFIlveIs1bsxwCDxPuRvtq0/04rOa0heoJOGJ3tA=";
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
