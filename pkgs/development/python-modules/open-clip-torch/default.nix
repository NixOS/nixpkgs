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

  stdenv,
}:
buildPythonPackage rec {
  pname = "open-clip-torch";
  version = "2.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlfoundations";
    repo = "open_clip";
    rev = "refs/tags/v${version}";
    hash = "sha256-XjPOsGet8VNzwEwzz14f1nF3XOgpkb4OERIc6VrDDZ8=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
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

  # -> On Darwin:
  # AttributeError: Can't pickle local object 'build_params.<locals>.<lambda>'
  # -> On Linux:
  # KeyError: Caught KeyError in DataLoader worker process 0
  disabledTestPaths = [ "tests/test_wds.py" ];

  disabledTests =
    [
      # requires network
      "test_download_pretrained_from_hfh"
      "test_inference_simple"
      "test_inference_with_data"
      "test_pretrained_text_encoder"
      "test_training_mt5"
      # fails due to type errors
      "test_num_shards"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
      "test_training"
      "test_training_coca"
      "test_training_unfreezing_vit"
      "test_training_clip_with_jit"
    ];

  meta = {
    description = "Open source implementation of CLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
    changelog = "https://github.com/mlfoundations/open_clip/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "open-clip";
    # Segfaults during pythonImportsCheck phase
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
  };
}
