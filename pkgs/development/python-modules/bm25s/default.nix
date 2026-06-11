{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  numpy,
  orjson,
  tqdm,
  pystemmer,
  huggingface-hub,
}:

buildPythonPackage (finalAttrs: {
  pname = "bm25s";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xhluca";
    repo = "bm25s";
    tag = "${finalAttrs.version}";
    hash = "sha256-/aIQCJnOInjaxRTbAJgYMs20zEayWLz+uBKGhqX5ULM=";
  };

  build-system = [
    setuptools
  ];

  env.BM25S_VERSION = finalAttrs.version;

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "bm25s" ];

  passthru.optional-dependencies = {
    core = [
      orjson
      tqdm
    ];
    stem = [ pystemmer ];
    hf = [ huggingface-hub ];
  };

  meta = {
    description = "Ultrafast implementation of BM25 in pure Python, powered by Numpy";
    homepage = "https://github.com/xhluca/bm25s";
    changelog = "https://github.com/xhluca/bm25s/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
  };
})
