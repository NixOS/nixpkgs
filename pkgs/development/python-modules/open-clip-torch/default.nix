{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  ftfy,
  huggingface-hub,
  protobuf,
  regex,
  safetensors,
  sentencepiece,
  timm,
  torch,
  torchvision,
  tqdm,

  # checks
  pytestCheckHook,
  braceexpand,
  pandas,
  transformers,
  webdataset,
}:
buildPythonPackage rec {
  pname = "open-clip-torch";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlfoundations";
    repo = "open_clip";
    tag = "v${version}";
    hash = "sha256-k4/u0XtfBmPSVKfEK3wHqJXtKAuUNkUnk1TLG2S6PPs=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    ftfy
    huggingface-hub
    protobuf
    regex
    safetensors
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

  # -> On Darwin:
  # AttributeError: Can't pickle local object 'build_params.<locals>.<lambda>'
  # -> On Linux:
  # KeyError: Caught KeyError in DataLoader worker process 0
  disabledTestPaths = [ "tests/test_wds.py" ];

  disabledTests = [
    # requires network
    "test_download_pretrained_from_hfh"
    "test_inference_simple"
    "test_inference_with_data"
    "test_pretrained_text_encoder"
    "test_training_mt5"

    # fails due to type errors
    "test_num_shards"

    # hangs forever
    "test_training"
  ];

  meta = {
    description = "Open source implementation of CLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
    changelog = "https://github.com/mlfoundations/open_clip/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "open-clip";
  };
}
