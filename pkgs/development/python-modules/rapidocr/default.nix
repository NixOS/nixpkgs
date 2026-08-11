{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  fetchurl,
  linkFarm,

  setuptools,
  setuptools-scm,
  colorlog,
  pyclipper,
  opencv-python,
  omegaconf,
  numpy,
  six,
  shapely,
  pyyaml,
  pillow,
  onnxruntime,
  tqdm,

  requests,
}:
let
  version = "3.9.2";

  # The models bundled into the wheel are the ones selected by the defaults in
  # `python/rapidocr/config.yaml`. Run `python tools/prepare_wheel_assets.py --skip-manifest-in`
  # from `python/` after a bump to check whether that selection changed; it prints the resolved
  # URLs and their checksums.
  models = linkFarm "rapidocr-models" {
    "PP-OCRv6_det_small.onnx" = fetchurl {
      url = "https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v${version}/onnx/PP-OCRv6/det/PP-OCRv6_det_small.onnx";
      hash = "sha256-CQ8Eq82dmnSYvE6/Z35Mub3OH+QZfdt+Up8e9E4f+U8=";
    };
    "ch_ppocr_mobile_v2.0_cls_mobile.onnx" = fetchurl {
      url = "https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v${version}/onnx/PP-OCRv4/cls/ch_ppocr_mobile_v2.0_cls_mobile.onnx";
      hash = "sha256-5HrO32YyMPiGP/GrDmTdLYK4OPzrWVcUbasYWonWIVw=";
    };
    "PP-OCRv6_rec_small.onnx" = fetchurl {
      url = "https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v${version}/onnx/PP-OCRv6/rec/PP-OCRv6_rec_small.onnx";
      hash = "sha256-bzJyRrUDiPPBdq4wS9lXZ+ptwMmukhU++MviELPBSIQ=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "rapidocr";
  inherit version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RapidAI";
    repo = "RapidOCR";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EdiYf8cM1+byEECK+3sRc7MC075BQV/PKIf/fC2Y1Lc=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  # Upstream ships an empty `models` directory and downloads the models at runtime. Pre-populate it
  # so that the default configuration works without network access.
  postPatch = ''
    ln -s ${models}/* rapidocr/models
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  # setuptools-scm derives the version from the git metadata, which fetchFromGitHub does not keep
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = [
    colorlog
    numpy
    omegaconf
    onnxruntime
    opencv-python
    pillow
    pyclipper
    pyyaml
    requests
    shapely
    six
    tqdm
  ];

  pythonImportsCheck = [ "rapidocr" ];

  # As of version 2.1.0, 61 out of 70 tests require internet access.
  # It's just not plausible to manually pick out ones that actually work
  # in a hermetic build environment anymore :(
  doCheck = false;

  meta = {
    description = "Cross platform OCR Library based on OnnxRuntime";
    homepage = "https://github.com/RapidAI/RapidOCR";
    changelog = "https://github.com/RapidAI/RapidOCR/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "rapidocr";
  };
})
