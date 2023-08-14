{ lib
, buildPythonPackage
, pythonRelaxDepsHook
, fetchFromGitHub
, attrdict
, beautifulsoup4
, cython
, fire
, fonttools
, lmdb
, lxml
, numpy
, opencv4
, openpyxl
, pdf2docx
, pillow
, premailer
, pyclipper
, pymupdf
, python-docx
, rapidfuzz
, scikit-image
, shapely
, tqdm
, paddlepaddle
, lanms-neo
, polygon3
}:

let

in buildPythonPackage rec {
  pname = "paddleocr";
  version = "2.6.1.0";

  src = fetchFromGitHub {
    owner = "PaddlePaddle";
    repo = "PaddleOCR";
    rev = "df54a7b4223c64a8480380f618fe95de3b8cf73b";
    hash = "sha256-H8sBu6+ApquJy/Kr56cYuAuBEz3cDTPh1QutfyzDnG4=";
  };

  # TODO: The tests depend, among possibly other things, on `cudatoolkit`.
  # But Cudatoolkit fails to install.
  # preCheck = "export HOME=$TMPDIR";
  # nativeCheckInputs = with pkgs; [ which cudatoolkit ];
  doCheck = false;

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "PyMuPDF" ];
  pythonRemoveDeps = [
    "imgaug"
    "visualdl"
    "opencv-python"
    "opencv-contrib-python"
  ];

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

  propagatedBuildInputs = [
    attrdict
    beautifulsoup4
    cython
    fire
    fonttools
    lmdb
    lxml
    numpy
    opencv4
    openpyxl
    pdf2docx
    pillow
    premailer
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

  meta = with lib; {
    homepage = "https://github.com/PaddlePaddle/PaddleOCR";
    license = licenses.asl20;
    description = "Multilingual OCR toolkits based on PaddlePaddle";
    longDescription = ''
      PaddleOCR aims to create multilingual, awesome, leading, and practical OCR
      tools that help users train better models and apply them into practice.
    '';
    maintainers = with maintainers; [ happysalada ];
  };
}
