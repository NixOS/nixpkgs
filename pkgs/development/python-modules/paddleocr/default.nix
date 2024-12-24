{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrdict,
  beautifulsoup4,
  cython,
  fire,
  fonttools,
  lmdb,
  lxml,
  numpy,
  opencv-python,
  openpyxl,
  pdf2docx,
  pillow,
  pyclipper,
  pymupdf,
  python-docx,
  rapidfuzz,
  scikit-image,
  shapely,
  tqdm,
  paddlepaddle,
  lanms-neo,
  polygon3,
}:

let
  version = "2.8.1";
in
buildPythonPackage {
  pname = "paddleocr";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PaddlePaddle";
    repo = "PaddleOCR";
    rev = "refs/tags/v${version}";
    hash = "sha256-TLNpb+CwLKvtmPppDuUbGyJorhmkVVW01J61+XUICYk=";
  };

  patches = [
    # The `ppocr.data.imaug` re-exports the `IaaAugment` and `CopyPaste`
    # classes. These classes depend on the `imgaug` package which is
    # unmaintained and has been removed from nixpkgs.
    #
    # The image OCR feature of PaddleOCR doesn't use these classes though, so
    # they work even after stripping the the `IaaAugment` and `CopyPaste`
    # exports. It probably breaks some of the OCR model creation tooling that
    # PaddleOCR provides, however.
    ./remove-import-imaug.patch
  ];

  # trying to relax only pymupdf makes the whole build fail
  pythonRelaxDeps = true;
  pythonRemoveDeps = [
    "imgaug"
    "visualdl"
    "opencv-contrib-python"
  ];

  propagatedBuildInputs = [
    attrdict
    beautifulsoup4
    cython
    fire
    fonttools
    lmdb
    lxml
    numpy
    opencv-python
    openpyxl
    pdf2docx
    pillow
    pyclipper
    pymupdf
    python-docx
    rapidfuzz
    scikit-image
    shapely
    tqdm
    paddlepaddle
    lanms-neo
    polygon3
  ];

  # TODO: The tests depend, among possibly other things, on `cudatoolkit`.
  # But Cudatoolkit fails to install.
  # preCheck = "export HOME=$TMPDIR";
  # nativeCheckInputs = with pkgs; [ which cudatoolkit ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/PaddlePaddle/PaddleOCR";
    license = licenses.asl20;
    description = "Multilingual OCR toolkits based on PaddlePaddle";
    longDescription = ''
      PaddleOCR aims to create multilingual, awesome, leading, and practical OCR
      tools that help users train better models and apply them into practice.
    '';
    changelog = "https://github.com/PaddlePaddle/PaddleOCR/releases/tag/v${version}";
    maintainers = with maintainers; [ happysalada ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
