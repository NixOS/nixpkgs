{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  jinja2,
  joblib,
  numpy,
  safetensors,
  tokenizers,
  tqdm,
  torch,
  transformers,
  scikit-learn,
  onnx,
  skops,
}:

buildPythonPackage (finalAttrs: {
  pname = "model2vec";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MinishLab";
    repo = "model2vec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hDNDvx2kbvJE3eR8UDgWIQYa7ZUWbtuzX76i+kpDJx4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = [
    jinja2
    joblib
    numpy
    safetensors
    tokenizers
    tqdm
  ];

  pythonImportsCheck = [ "model2vec" ];

  passthru.optional-dependencies = {
    distill = [
      torch
      transformers
      scikit-learn
    ];
    onnx = [
      onnx
      torch
    ];
    inference = [
      scikit-learn
      skops
    ];
    quantization = [ scikit-learn ];
  };

  meta = {
    description = "Fast State-of-the-Art Static Embeddings";
    homepage = "https://github.com/MinishLab/model2vec";
    changelog = "https://github.com/MinishLab/model2vec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
  };
})
