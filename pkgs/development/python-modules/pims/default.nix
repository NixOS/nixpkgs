{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, numpy
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, scikit-image
=======
, scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, slicerator
}:

buildPythonPackage rec {
  pname = "pims";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QdllA1QTSJ8vWaSJ0XoUanX53sb4RaOmdXBCFEsoWMU=";
  };

  propagatedBuildInputs = [
    slicerator
    imageio
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "pims"
  ];

  pytestFlagsArray = [
    "-W"
<<<<<<< HEAD
    "ignore::Warning"
=======
    "ignore::DeprecationWarning"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTests = [
    # NotImplementedError: Do not know how to deal with infinite readers
    "TestVideo_ImageIO"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    # AssertionError: Tuples differ: (377, 505, 4) != (384, 512, 4)
    "pims/tests/test_display.py"
  ];

  meta = with lib; {
    description = "Module to load video and sequential images in various formats";
    homepage = "https://github.com/soft-matter/pims";
    changelog = "https://github.com/soft-matter/pims/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
  meta = with lib; {
    description = "Python Image Sequence: Load video and sequential images in many formats with a simple, consistent interface";
    homepage = "https://github.com/soft-matter/pims";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
