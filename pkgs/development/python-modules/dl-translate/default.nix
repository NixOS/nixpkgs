{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  protobuf,
  sentencepiece,
  torch,
  tqdm,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "dl-translate";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xhluca";
    repo = "dl-translate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vAEdh9iTmZJar8nzi7jCResqA/Qmurn5BghnM+TgnmQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    protobuf
    sentencepiece
    torch
    tqdm
    transformers
  ];

  pythonImportsCheck = [ "dl_translate" ];

  # tests require model downloads
  doCheck = false;

  meta = {
    description = "Deep learning-based translation library built on Huggingface transformers";
    homepage = "https://github.com/xhluca/dl-translate";
    changelog = "https://github.com/xhluca/dl-translate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seirl ];
  };
})
