{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, future
, numpy
, pillow
, fetchpatch
, scipy
, scikit-learn
, scikitimage
, threadpoolctl
}:

buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-47jAeHMJPBk7GpUvXtQuJchgiSy6M50anftsuXWk2ag=";
  };

  propagatedBuildInputs = [
    future
    numpy
    pillow
    scipy
    scikit-learn
    scikitimage
    threadpoolctl
  ];

  # see https://github.com/MIC-DKFZ/batchgenerators/pull/78
  postPatch = ''
    substituteInPlace setup.py \
      --replace '"unittest2",' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
