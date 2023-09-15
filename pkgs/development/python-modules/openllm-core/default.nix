{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, accelerate
, attrs
, bentoml
, bitsandbytes
, cattrs
, datasets
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, inflection
, mypy-extensions
, orjson
, peft
, ray
, transformers
, typing-extensions
}:

buildPythonPackage rec {
  pname = "openllm-core";
  version = "0.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "OpenLLM";
    rev = "refs/tags/v${version}";
    hash = "sha256-uRXsIcsgu+EAxzUGKt9+PIoO1kvo6rWT569D5qXFrAQ=";
  };

  sourceRoot = "source/openllm-core";

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    bentoml
    cattrs
    inflection
    mypy-extensions
    orjson
    typing-extensions
  ];

  passthru.optional-dependencies = {
    vllm = [
      ray
      # vllm
    ];
    fine-tune = [
      accelerate
      bitsandbytes
      datasets
      peft
      transformers
      # trl
    ] ++ transformers.optional-dependencies.torch
      ++ transformers.optional-dependencies.tokenizers
      ++ transformers.optional-dependencies.accelerate;
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
