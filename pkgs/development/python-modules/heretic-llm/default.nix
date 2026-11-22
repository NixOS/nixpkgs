{
  lib,
  accelerate,
  bitsandbytes,
  buildPythonPackage,
  datasets,
  fetchFromGitHub,
  hf-transfer,
  huggingface-hub,
  imageio,
  immutabledict,
  kernels,
  langdetect,
  lm-eval,
  matplotlib,
  numpy,
  optuna,
  peft,
  psutil,
  py-cpuinfo,
  pydantic-settings,
  questionary,
  rich,
  scikit-learn,
  tomli-w,
  torchvision,
  transformers,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "heretic-llm";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "heretic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dWrvkB/+rvZGPK4s61xN0t1su7uNR6NN8HBOl8Pl6I8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.21,<0.13.0" "uv_build"
  '';

  pythonRelaxDeps = [
    "accelerate"
    "bitsandbytes"
    "datasets"
    "huggingface-hub"
    "optuna"
    "peft"
    "pydantic-settings"
    "rich"
    "transformers"
  ];

  build-system = [ uv-build ];

  dependencies = [
    accelerate
    bitsandbytes
    datasets
    hf-transfer
    huggingface-hub
    immutabledict
    kernels
    langdetect
    lm-eval
    optuna
    peft
    psutil
    py-cpuinfo
    pydantic-settings
    questionary
    rich
    tomli-w
    torchvision
    transformers
  ];

  optional-dependencies = {
    research = [
      # geom-median
      imageio
      matplotlib
      numpy
      # pacmap
      scikit-learn
    ];
  };

  pythonImportsCheck = [ "heretic" ];

  meta = {
    description = "Tool to remove censorship removal for language models";
    homepage = "https://github.com/p-e-w/heretic";
    changelog = "https://github.com/p-e-w/heretic/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      agpl3Only
      agpl3Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
