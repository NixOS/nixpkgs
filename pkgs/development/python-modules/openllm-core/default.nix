{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonRelaxDepsHook,
  accelerate,
  attrs,
  bitsandbytes,
  bentoml,
  cattrs,
  click-option-group,
  datasets,
  deepmerge,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  inflection,
  mypy-extensions,
  orjson,
  peft,
  transformers,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "openllm-core";
  version = "0.4.44";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "OpenLLM";
    rev = "refs/tags/v${version}";
    hash = "sha256-kRR715Vnt9ZAmxuWvtH0z093crH0JFrEKPtbjO3QMRc=";
  };

  sourceRoot = "${src.name}/openllm-core";

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatch-vcs==0.3.0" "hatch-vcs" \
      --replace-fail "hatchling==1.18.0" "hatchling" \
      --replace-fail "hatch-fancy-pypi-readme==23.1.0" "hatch-fancy-pypi-readme"
  '';

  pythonRelaxDeps = [ "cattrs" ];

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
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

  optional-dependencies = {
    vllm = [
      # vllm
    ];
    bentoml = [ bentoml ];
    fine-tune =
      [
        accelerate
        bitsandbytes
        datasets
        peft
        transformers
        # trl
      ]
      ++ transformers.optional-dependencies.torch
      ++ transformers.optional-dependencies.tokenizers;
    full =
      with optional-dependencies;
      (
        vllm
        # use absolute path to disambiguate with derivbation argument
        ++ optional-dependencies.bentoml
        ++ fine-tune
      );
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
