{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build inputs
  numpy,
  opencv4,
  scipy,
  pandas,
  pillow,
  pyyaml,
  iopath,
  pdfplumber,
  pdf2image,
  google-cloud-vision,
  pytesseract,
  torch,
  torchvision,
  effdet,
  # check inputs
  pytestCheckHook,
}:
let
  pname = "layoutparser";
  version = "0.3.4";
  optional-dependencies = {
    ocr = [
      google-cloud-vision
      pytesseract
    ];
    gcv = [ google-cloud-vision ];
    tesseract = [ pytesseract ];
    layoutmodels = [
      torch
      torchvision
      effdet
    ];
    effdet = [
      torch
      torchvision
      effdet
    ];
    # paddledetection = [ paddlepaddle ]
  };
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Layout-Parser";
    repo = "layout-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-qBzcIUmgnGy/Xn/B+7UrLrRhCvCkapL+ymqGS2sMVgA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "opencv-python" "opencv"
  '';

  propagatedBuildInputs = [
    numpy
    opencv4
    scipy
    pandas
    pillow
    pyyaml
    iopath
    pdfplumber
    pdf2image
  ];

  pythonImportsCheck = [ "layoutparser" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.ocr;

  disabledTests = [
    "test_PaddleDetectionModel" # requires paddlepaddle not yet packaged
    # requires detectron2 not yet packaged
    "test_Detectron2Model"
    "test_AutoModel"
    # requires effdet (disable for now until effdet builds on darwin)
    "test_EffDetModel"
    # problems with google-cloud-vision
    # AttributeError: module 'google.cloud.vision' has no attribute 'types'
    "test_gcv_agent"
    "test_viz"
    #  - Failed: DID NOT RAISE <class 'ImportError'>
    "test_when_backends_are_not_loaded"
  ];

  disabledTestPaths = [
    "tests_deps/test_only_detectron2.py" # requires detectron2 not yet packaged
    "tests_deps/test_only_effdet.py" # requires effdet (disable for now until effdet builds on darwin)
    "tests_deps/test_only_paddledetection.py" # requires paddlepaddle not yet packaged
  ];

  passthru.optional-dependencies = optional-dependencies;

  meta = with lib; {
    description = "A unified toolkit for Deep Learning Based Document Image Analysis";
    homepage = "https://github.com/Layout-Parser/layout-parser";
    changelog = "https://github.com/Layout-Parser/layout-parser/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
