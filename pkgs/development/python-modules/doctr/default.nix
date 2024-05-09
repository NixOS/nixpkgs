{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

, fetchurl
, python3
, runCommand
, runCommandLocal

, importlib-metadata
, numpy
, scipy
, h5py
, opencv4
, pypdfium2-bin
, pyclipper
, shapely
, langdetect
, rapidfuzz
, matplotlib
, weasyprint
, pillow
, defusedxml
, mplcursors
, unidecode
, tqdm
, huggingface-hub
, torch
, torchvision
, onnx
}:

let
  # Note [doctr-cache-offline]:
  # Pre-download some doctr models here to use in offline-only NixOS tests.
  # You can find the model URLs in doctr/models/{detection,recognition}/MODEL_TYPE/pytorch.py
  doctr-offline-models-dir = runCommandLocal "doctr-cache" {} ''
    mkdir -p $out/models

    ln -s ${fetchurl {
      # `db_resnet50_rotation` from: https://github.com/mindee/doctr/blob/v0.7.0/doctr/models/detection/differentiable_binarization/pytorch.py#L44-L49
      url = "https://github.com/mindee/doctr/releases/download/v0.4.1/db_resnet50-1138863a.pt";
      sha256 = "09pp7f51cimgfvh4a5ykfsvyrxid861vr42sfllra7g63wx8cf0i";
    }} "$out/models/db_resnet50-1138863a.pt&src=0"  # the '&src=0' is intended, doctr looks for the file named this way

    ln -s ${fetchurl {
      # `crnn_vgg16_bn` from: https://github.com/mindee/doctr/blob/v0.7.0/doctr/models/recognition/crnn/pytorch.py#L23-L29
      url = "https://github.com/mindee/doctr/releases/download/v0.3.1/crnn_vgg16_bn-9762b0b0.pt";
      sha256 = "1qknw4y1jlvni972kg2sjxki8sb90x7p18ba1f21abfgvjqb0qlp";
    }} "$out/models/crnn_vgg16_bn-9762b0b0.pt&src=0"  # the '&src=0' is intended, doctr looks for the file named this way
  '';

in

buildPythonPackage rec {
  pname = "python-doctr";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mindee";
    repo = "doctr";
    rev = "v${version}";
    hash = "sha256-mBkSr2t9w4VATpeinLvIq7lpGnkqhR99HG3EjNTPSrk=";
  };

  patches = [
    # TODO: Remove when https://github.com/mindee/doctr/pull/1373 is merged and available, or when nixpkgs has newer versions
    (fetchpatch {
      url = "https://github.com/mindee/doctr/commit/e00cc79696a0b8d163f5429e94d8bbe944cf02ef.patch";
      name = "doctr-Relax-Pillow-version-bounds.patch";
      hash = "sha256-oUBvp3Eqj+h2G1D7VQLPbXpdUTr3xM4n30rKaj+YomA=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace "opencv-python" "opencv"
  '';

  propagatedBuildInputs = [
    # Main dependencies from:
    #     https://github.com/mindee/doctr/blob/v0.7.0/pyproject.toml#L34-L55
    importlib-metadata
    numpy
    scipy
    h5py
    opencv4
    pypdfium2-bin
    pyclipper
    shapely
    langdetect
    rapidfuzz
    matplotlib
    weasyprint
    pillow
    defusedxml
    mplcursors
    unidecode
    tqdm
    huggingface-hub

    # Torch dependencies from:
    #     https://github.com/mindee/doctr/blob/v0.7.0/pyproject.toml#L62-L66
    torch
    torchvision
    onnx
  ];

  # Tests produce
  #     TypeError: calling <function parseq at 0x7ffecb71f5b0> returned PARSeq(...), not a test
  # Not clear yet what's needed to make them work.
  doCheck = false;

  passthru.tests =
    let
      simpleWordDetectionTest = inputFile: expectedDetectedWord:
        runCommand
          "doctr-ocr-test-output"
          {
            nativeBuildInputs = [
              (python3.withPackages (ps: with ps; [ doctr ]))
            ];
          }
          ''
            python ${./doctr-ocr-example.py} --offline-models-dir ${doctr-offline-models-dir} --input-file "${inputFile}" > $out
            grep --quiet -F -i '${expectedDetectedWord}' "$out" || (echo >&2 "doctr failed to detect the word '${expectedDetectedWord}' in input file '${inputFile}'; detection output is in $out" && exit 1)
          '';
    in {
      image-ocr = simpleWordDetectionTest ./nixos-website-screenshot.png "declarative";
      pdf-ocr = simpleWordDetectionTest ./nixos-website-screenshot.pdf "declarative";
    };

  meta = with lib; {
    description = "Seamless, high-performing & accessible library for OCR-related tasks powered by Deep Learning";
    homepage = "https://mindee.github.io/doctr/";
    license = licenses.asl20;
    maintainers = with maintainers; [ chpatrick nh2 ];
    platforms = [ "x86_64-linux" ]; # because `pypdfium2` is only packed for this so far
  };
}
