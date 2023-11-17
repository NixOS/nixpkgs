{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv

# build-system
, setuptools

# dependencies
, ftfy
, huggingface-hub
, protobuf
, regex
, sentencepiece
, timm
, torch
, torchvision
, tqdm

# optional-dependencies
, braceexpand
, fsspec
, pandas
, transformers
, webdataset

# tests
, pytestCheckHook
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

  passthru.optional-dependencies.training = [
    braceexpand
    fsspec
    pandas
    transformers
    webdataset
  ];

  pythonImportsCheck = [
    "open_clip"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    transformers
  ] ++ passthru.optional-dependencies.training;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # requires downloads from hugging face
    "test_download_pretrained_from_hfh"
    "test_pretrained_text_encoder"
    "test_inference_with_data"
    "test_inference_simple"
    "test_training_mt5"
  ] ++ lib.optionals (stdenv.isAarch64) [
    # dataloader crashes
    "test_training"
    "test_training_coca"
    "test_training_unfreezing_vit"
    "test_training_clip_with_jit"
    "test_single_source"
    "test_two_sources"
    "test_two_sources_same_weights"
    "test_two_sources_with_upsampling"
  ];

  meta = with lib; {
    changelog = "https://github.com/mlfoundations/open_clip/releases/tag/v${version}";
    description = "An open source implementation of CLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
