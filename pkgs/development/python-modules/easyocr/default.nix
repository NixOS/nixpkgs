{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hdf5,
  numpy,
  onnx,
  opencv4,
  pillow,
  pyaml,
  pyclipper,
  python-bidi,
  pythonOlder,
  scikit-image,
  scipy,
  shapely,
  torch,
  torchvision,
}:

buildPythonPackage rec {
  pname = "easyocr";
  version = "1.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JaidedAI";
    repo = "EasyOCR";
    rev = "refs/tags/v${version}";
    hash = "sha256-9mrAxt2lphYtLW81lGO5SYHsnMnSA/VpHiY2NffD/Js=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "opencv-python-headless" "" \
      --replace "ninja" ""
  '';

  propagatedBuildInputs = [
    hdf5
    numpy
    opencv4
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

  nativeCheckInputs = [ onnx ];

  pythonImportsCheck = [ "easyocr" ];

  meta = with lib; {
    description = "Ready-to-use OCR with 80+ supported languages and all popular writing scripts";
    mainProgram = "easyocr";
    homepage = "https://github.com/JaidedAI/EasyOCR";
    changelog = "https://github.com/JaidedAI/EasyOCR/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
