{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
  pandas,
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

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "batchgenerators";
    rev = "v${version}";
    hash = "sha256-lvsen2AFRwFjLMgxXBQ9/xxmCOBx2D2PBIl0KpOzR70=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    pillow
    scipy
    scikit-learn
    scikit-image
    threadpoolctl
  ];

  # see https://github.com/MIC-DKFZ/batchgenerators/pull/78 and
  # https://github.com/MIC-DKFZ/batchgenerators/pull/130
  pythonRemoveDeps = [
    "unittest2"
    "future"
  ];

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

  meta = with lib; {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
