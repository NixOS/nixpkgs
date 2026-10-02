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
  huggingface-hub,
  multiprocess,
  numpy,
  pandas,
  pyarrow,
  pyyaml,
  tqdm,
  xxhash,
}:
buildPythonPackage (finalAttrs: {
  pname = "datasets";
  version = "5.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "datasets";
    tag = finalAttrs.version;
    hash = "sha256-lQL9DeEU5FdPQESO7kwsV9zl8UHwweFKeFhp1587EYc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dill
    filelock
    fsspec
    huggingface-hub
    multiprocess
    numpy
    pandas
    pyarrow
    pyyaml
    tqdm
    xxhash
  ]
  ++ fsspec.optional-dependencies.http;

  # Tests require pervasive internet access
  doCheck = false;

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
