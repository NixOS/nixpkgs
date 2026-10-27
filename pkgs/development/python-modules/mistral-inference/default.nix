{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  poetry-core,

  # dependencies
  fire,
  mistral-common,
  pillow,
  safetensors,
  simple-parsing,
  xformers,

  # tests
  mamba-ssm,
  pycountry,
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthu
  mistral-inference,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistral-inference";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-inference";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dcBlZWrgQn7eiNsjTS8882X9quHbgTfXxTK7HLpbLM8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    fire
    mistral-common
    pillow
    pycountry
    safetensors
    simple-parsing
    xformers
  ];

  nativeCheckInputs = [
    mamba-ssm
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Tests require GPU access in the sandbox
  doCheck = false;

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # AttributeError("module 'ast' has no attribute 'Num'")
    "test_generation_mamba"
  ];

  passthru.gpuCheck = mistral-inference.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  pythonImportsCheck = [ "mistral_inference" ];

  meta = {
    description = "High-performance library for running Mistral AI models on local hardware";
    homepage = "https://github.com/mistralai/mistral-inference";
    changelog = "https://github.com/mistralai/mistral-inference/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mana-byte
    ];
    mainProgram = "mistral-chat";
    # Explicitly requires an NVIDIA GPU to work
    broken = !config.cudaSupport;
  };
})
