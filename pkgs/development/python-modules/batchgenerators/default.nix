{
  lib,
  buildPythonPackage,
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

buildPythonPackage (finalAttrs: {
  pname = "batchgenerators";
  version = "0.25.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "batchgenerators";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z4zeqFtYMB0l+kEtzQh++RvpAd6WSxXSzJOJ9NWPqnQ=";
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

  nativeCheckInputs = [ pytestCheckHook ];

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
    changelog = "https://github.com/MIC-DKFZ/batchgenerators/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
