{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  accelerate,
  bitsandbytes,
  datasets,
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
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "heretic-llm";
  version = "1.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "heretic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jIWvHRsRo4wtos+2oNA8n0kz0GPLb03qEFsOQKTuMo8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.11,<0.9.0" "uv_build"
  '';

  pythonRelaxDeps = [
    "datasets"
    "huggingface-hub"
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
