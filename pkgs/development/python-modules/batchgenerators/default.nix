{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  future,
  numpy,
  pillow,
  scipy,
  scikit-learn,
  scikit-image,
  threadpoolctl,
}:

buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "batchgenerators";
    tag = "v${version}";
    hash = "sha256-lvsen2AFRwFjLMgxXBQ9/xxmCOBx2D2PBIl0KpOzR70=";
  };

  build-system = [ setuptools ];

  dependencies = [
    future
    numpy
    pillow
    scipy
    scikit-learn
    scikit-image
    threadpoolctl
  ];

  # see https://github.com/MIC-DKFZ/batchgenerators/pull/78
  pythonRemoveDeps = [ "unittest2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # see https://github.com/MIC-DKFZ/batchgenerators/pull/78
  disabledTestPaths = [ "tests/test_axis_mirroring.py" ];

  pythonImportsCheck = [
    "batchgenerators"
    "batchgenerators.augmentations"
    "batchgenerators.dataloading"
    "batchgenerators.datasets"
    "batchgenerators.transforms"
    "batchgenerators.utilities"
  ];

  meta = {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
