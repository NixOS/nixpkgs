{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  anyio,
  filelock,
  fonttools,
  fsspec,
  hf-transfer,
  huggingface-hub,
  matplotlib,
  mlx,
  numpy,
  opencv-python,
  piexif,
  pillow,
  platformdirs,
  protobuf,
  pyyaml,
  regex,
  requests,
  safetensors,
  sentencepiece,
  tokenizers,
  toml,
  torch,
  tqdm,
  transformers,
  twine,
  urllib3,

  # tests
  gitMinimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mflux";
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mflux-community";
    repo = "mflux";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-S4JjxJSHxebSku8ppxxgWWR6gOkzUN8NoTT5/Mh+Djw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.5,<0.13.0" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonRelaxDeps = [
    "huggingface-hub"
    "mlx"
    "pillow"
    "transformers"
    "urllib3"
  ];
  dependencies = [
    anyio
    filelock
    fonttools
    fsspec
    hf-transfer
    huggingface-hub
    matplotlib
    mlx
    numpy
    opencv-python
    piexif
    pillow
    platformdirs
    protobuf
    pyyaml
    regex
    requests
    safetensors
    sentencepiece
    tokenizers
    toml
    torch
    tqdm
    transformers
    twine
    urllib3
  ];

  pythonImportsCheck = [ "mflux" ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isLinux [
    # mlx's CPU backend has no "memory_size" in mx.device_info()
    "test_verify_retries_survive_the_low_ram_memory_saver"

    # Tolerances are tuned for Metal and miss on the CPU backend
    "test_flash_sdpa_avoids_materializing_dense_scores"
    "test_full_precision_with_attention_chunks_matches_legacy_within_rounding"
    "test_shared_qwen3_vl_pieces_reproduce_the_recorded_outputs"
  ];

  meta = {
    description = "MLX native implementations of state-of-the-art generative image models";
    homepage = "https://github.com/mflux-community/mflux";
    changelog = "https://github.com/mflux-community/mflux/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
