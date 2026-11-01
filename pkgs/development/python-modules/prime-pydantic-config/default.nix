{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  pydantic,

  # optional-dependencies
  pyyaml,
  tomli,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prime-pydantic-config";
  version = "0.4.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrimeIntellect-ai";
    repo = "pydantic-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uj103l/dk+4Duc6QDm/mS8Pnv2wHvMtfYTqgMEWxbw8=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    pydantic
  ];

  optional-dependencies = {
    yaml = [ pyyaml ];
    toml = [ tomli ];
  };

  pythonImportsCheck = [ "pydantic_config" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    description = "Pydantic-driven CLI with TOML/YAML config file support for ML";
    homepage = "https://github.com/PrimeIntellect-ai/pydantic-config";
    changelog = "https://github.com/PrimeIntellect-ai/pydantic-config/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
