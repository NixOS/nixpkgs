{
  lib,
  aiohttp,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  fsspec,
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
buildPythonPackage rec {
  pname = "datasets";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "datasets";
    tag = version;
    hash = "sha256-Cr25PgLNGX/KcFZE5h1oiaDW9J50ccMqA5z3q4sITus=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    dill
    fsspec
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
    changelog = "https://github.com/huggingface/datasets/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
