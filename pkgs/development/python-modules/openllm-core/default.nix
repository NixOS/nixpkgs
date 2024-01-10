{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, accelerate
, attrs
, bitsandbytes
, bentoml
, cattrs
, click-option-group
, datasets
, deepmerge
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, inflection
, mypy-extensions
, orjson
, peft
, transformers
, typing-extensions
}:

buildPythonPackage rec {
  pname = "openllm-core";
  version = "0.4.41";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "OpenLLM";
    rev = "refs/tags/v${version}";
    hash = "sha256-9mr6sw4/h5cYSmo1CDT2SKq4NVz1ZcoyqnYOwhlfaiQ=";
  };

  sourceRoot = "source/openllm-core";

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    # not listed in pyproject.toml, but required at runtime
    click-option-group
    deepmerge
    inflection
    mypy-extensions
    orjson
    typing-extensions
  ];

  passthru.optional-dependencies = {
    vllm = [
      # vllm
    ];
    bentoml = [
      bentoml
    ];
    fine-tune = [
      accelerate
      bitsandbytes
      datasets
      peft
      transformers
      # trl
    ] ++ transformers.optional-dependencies.torch
      ++ transformers.optional-dependencies.tokenizers;
    full = with passthru.optional-dependencies; (
      vllm
      # use absolute path to disambiguate with derivbation argument
      ++ passthru.optional-dependencies.bentoml
      ++ fine-tune );
  };

  # there is no tests
  doCheck = false;

  pythonImportsCheck = [ "openllm_core" ];

  meta = with lib; {
    description = "Core components for OpenLLM";
    homepage = "https://github.com/bentoml/OpenLLM/tree/main/openllm-core";
    changelog = "https://github.com/bentoml/OpenLLM/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
