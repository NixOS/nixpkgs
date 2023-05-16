{ lib
, buildPythonPackage
, fetchFromGitHub
, hdf5
, numpy
<<<<<<< HEAD
, onnx
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, opencv3
, pillow
, pyaml
, pyclipper
, python-bidi
<<<<<<< HEAD
, pythonOlder
, scikit-image
, scipy
, shapely
, torch
, torchvision
=======
, torch
, scikitimage
, scipy
, shapely
, torchvision
, onnx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "easyocr";
<<<<<<< HEAD
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "JaidedAI";
    repo = "EasyOCR";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-01Exz55eTIO/xzdq/dzV+ELkU75hpxe/EbjIqLBA8h0=";
=======
    rev = "v${version}";
    hash = "sha256-f+JBSnFMRvVlhRRiL1rJb7a0CNjZPuh6r8r3K1meQCk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace requirements.txt \
<<<<<<< HEAD
      --replace "opencv-python-headless" "" \
=======
      --replace "opencv-python-headless<=4.5.4.60" "" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace "ninja" ""
  '';

  propagatedBuildInputs = [
<<<<<<< HEAD
    hdf5
    numpy
    opencv3
    pillow
    pyaml
    pyclipper
    python-bidi
    scikit-image
    scipy
    shapely
    torch
    torchvision
  ];

  nativeCheckInputs = [
    onnx
  ];

  pythonImportsCheck = [
    "easyocr"
  ];
=======
    scikitimage
    hdf5
    python-bidi
    numpy
    opencv3
    torchvision
    pillow
    pyaml
    pyclipper
    torch
    scipy
    shapely
  ];

  nativeCheckInputs = [ onnx ];

  pythonImportsCheck = [ "easyocr" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Ready-to-use OCR with 80+ supported languages and all popular writing scripts";
    homepage = "https://github.com/JaidedAI/EasyOCR";
<<<<<<< HEAD
    changelog = "https://github.com/JaidedAI/EasyOCR/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
