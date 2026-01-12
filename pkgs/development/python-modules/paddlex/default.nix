{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
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

buildPythonPackage rec {
  pname = "paddlex";
  version = "3.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PaddlePaddle";
    repo = "PaddleX";
    tag = "v${version}";
    hash = "sha256-IK+Mk2IWrDGCLH3nw5/WR0uPIFBAsb/h4/MMmSlxT9s=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "pyyaml"
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
    changelog = "https://github.com/PaddlePaddle/PaddleX/releases/tag/${src.tag}";
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
