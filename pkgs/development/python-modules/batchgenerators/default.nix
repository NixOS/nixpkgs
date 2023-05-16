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
<<<<<<< HEAD
, scikit-image
=======
, scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, threadpoolctl
}:

buildPythonPackage rec {
  pname = "batchgenerators";
<<<<<<< HEAD
  version = "0.25";
=======
  version = "0.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L2mWH2t8PN9o1M67KDdl1Tj2ZZ02MY4icsJY2VNrj3A=";
=======
    hash = "sha256-47jAeHMJPBk7GpUvXtQuJchgiSy6M50anftsuXWk2ag=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    future
    numpy
    pillow
    scipy
    scikit-learn
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
