{
  lib,
  accelerate,
  bitsandbytes,
  buildPythonPackage,
  datasets,
  fetchFromGitHub,
  # geom-median,
  hf-transfer,
  huggingface-hub,
  imageio,
  kernels,
  matplotlib,
  numpy,
  optuna,
  # pacmap,
  peft,
  psutil,
  pydantic-settings,
  questionary,
  rich,
  scikit-learn,
  transformers,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "heretic-llm";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "heretic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KmqbOAOII1SP7wpdvGxtzQJt5NmlnF/o99NuZ21vO0s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.11,<0.9.0" "uv_build"
  '';

  pythonRelaxDeps = [
    "huggingface-hub"
    "transformers"
  ];

  build-system = [ uv-build ];

  dependencies = [
    accelerate
    bitsandbytes
    datasets
    hf-transfer
    huggingface-hub
    kernels
    optuna
    peft
    psutil
    pydantic-settings
    questionary
    rich
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
