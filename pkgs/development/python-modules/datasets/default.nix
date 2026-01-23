{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,

  # dependencies
  dill,
  filelock,
  fsspec,
  httpx,
  huggingface-hub,
  multiprocess,
  numpy,
  pandas,
  pyarrow,
  pyyaml,
  requests,
  tqdm,
  xxhash,
}:
buildPythonPackage rec {
  pname = "datasets";
  version = "4.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "datasets";
    tag = version;
    hash = "sha256-4uKGbT/EtPD1nk66SZu0r4lqGSQXMHkZh8q8x6g3YqU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dill
    filelock
    fsspec
    httpx
    huggingface-hub
    multiprocess
    numpy
    pandas
    pyarrow
    pyyaml
    requests
    tqdm
    xxhash
  ];

  pythonRelaxDeps = [
    # https://github.com/huggingface/datasets/blob/a256b85cbc67aa3f0e75d32d6586afc507cf535b/setup.py#L117
    # "pin until dill has official support for determinism"
    "dill"
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
