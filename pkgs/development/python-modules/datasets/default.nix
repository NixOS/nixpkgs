{
  lib,
  aiohttp,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  fsspec,
  httpx,
  huggingface-hub,
  multiprocess,
  numpy,
  packaging,
  pandas,
  pyarrow,
  requests,
  responses,
  setuptools,
  tqdm,
  xxhash,
}:
buildPythonPackage (finalAttrs: {
  pname = "datasets";
  version = "4.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "datasets";
    tag = finalAttrs.version;
    hash = "sha256-4lJ3j9Eg4Xi8Pp6J3cqz8+JNiybPqHLUpqVCIwskaM8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    dill
    fsspec
    httpx
    huggingface-hub
    multiprocess
    numpy
    packaging
    pandas
    pyarrow
    requests
    responses
    tqdm
    xxhash
  ];

  pythonRelaxDeps = [
    # https://github.com/huggingface/datasets/blob/a256b85cbc67aa3f0e75d32d6586afc507cf535b/setup.py#L117
    # "pin until dill has official support for determinism"
    "dill"
    "multiprocess"
    # https://github.com/huggingface/datasets/blob/a256b85cbc67aa3f0e75d32d6586afc507cf535b/setup.py#L129
    # "to support protocol=kwargs in fsspec's `open`, `get_fs_token_paths`"
    "fsspec"
  ];

  # Tests require pervasive internet access
  doCheck = false;

  # Module import will attempt to create a cache directory
  postFixup = "export HF_MODULES_CACHE=$TMPDIR";

  pythonImportsCheck = [ "datasets" ];

  meta = {
    description = "Open-access datasets and evaluation metrics for natural language processing";
    mainProgram = "datasets-cli";
    homepage = "https://github.com/huggingface/datasets";
    changelog = "https://github.com/huggingface/datasets/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
})
