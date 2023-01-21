{ lib
, buildPythonPackage
, fetchFromGitHub
, hdf5
, numpy
, opencv3
, pillow
, pyaml
, pyclipper
, python-bidi
, torch
, scikitimage
, scipy
, shapely
, torchvision
, onnx
}:

buildPythonPackage rec {
  pname = "easyocr";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "JaidedAI";
    repo = "EasyOCR";
    rev = "v${version}";
    sha256 = "sha256-f+JBSnFMRvVlhRRiL1rJb7a0CNjZPuh6r8r3K1meQCk=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "opencv-python-headless<=4.5.4.60" "" \
      --replace "ninja" ""
  '';

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Ready-to-use OCR with 80+ supported languages and all popular writing scripts";
    homepage = "https://github.com/JaidedAI/EasyOCR";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
