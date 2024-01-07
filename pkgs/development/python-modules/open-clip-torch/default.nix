{ lib
, stdenv
, buildPythonPackage
, braceexpand
, ftfy
, huggingface-hub
, pandas
, protobuf
, pytestCheckHook
, regex
, sentencepiece
, timm
, torch
, torchvision
, tqdm
, transformers
, setuptools
, webdataset
, wheel
, fetchFromGitHub
}:
buildPythonPackage rec {
  pname = "open-clip-torch";
  version = "2.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlfoundations";
    repo = "open_clip";
    rev = "v${version}";
    hash = "sha256-Txm47Tc4KMbz1i2mROT+IYbgS1Y0yHK80xY0YldgBFQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    ftfy
    huggingface-hub
    protobuf
    regex
    sentencepiece
    timm
    torch
    torchvision
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    braceexpand
    pandas
    transformers
    webdataset
  ];

  pythonImportsCheck = [ "open_clip" ];

  disabledTestPaths = lib.optionals (stdenv.isAarch64 || stdenv.isDarwin) [
    "tests/test_wds.py"
  ];

  disabledTests = [
    # requires network
    "test_download_pretrained_from_hfh"
    "test_inference_simple"
    "test_inference_with_data"
    "test_pretrained_text_encoder"
    "test_training_mt5"
  ] ++ lib.optionals (stdenv.isAarch64 && stdenv.isLinux) [
    "test_training"
    "test_training_coca"
    "test_training_unfreezing_vit"
    "test_training_clip_with_jit"
  ];

  meta = with lib; {
    description = "An open source implementation of CLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
    license = licenses.asl20;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "open-clip";
  };
}
