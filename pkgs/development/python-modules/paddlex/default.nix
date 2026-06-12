{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  pillow,
  pyyaml,
  chardet,
  colorlog,
  filelock,
  pandas,
  prettytable,
  py-cpuinfo,
  pydantic,
  requests,
  ruamel-yaml,
  typing-extensions,
  ujson,
  gputil,
  huggingface-hub,
  modelscope,
  aistudio-sdk,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "paddlex";
  version = "3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PaddlePaddle";
    repo = "PaddleX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hmy70oTITF/olEyQELnZIotk2afvO+zxCcLZwVHuUWc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "pyyaml"
    "numpy"
  ];

  dependencies = [
    chardet
    colorlog
    filelock
    numpy
    pandas
    pillow
    prettytable
    py-cpuinfo
    pydantic
    pyyaml
    requests
    ruamel-yaml
    typing-extensions
    ujson
    gputil
    huggingface-hub
    modelscope
    aistudio-sdk
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/PaddlePaddle/PaddleX";
    license = lib.licenses.asl20;
    description = "All-in-One Development Tool based on PaddlePaddle";
    changelog = "https://github.com/PaddlePaddle/PaddleX/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    hasNoMaintainersButDependents = true;
  };
})
