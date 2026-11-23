{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  torch,

  # optional-dependencies
  apache-tvm-ffi,
  nvidia-cutlass-dsl,
  packaging,
}:

buildPythonPackage (finalAttrs: {
  pname = "attn-gym";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "attention-gym";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftytGXYmSf2iPYWw7towfVk8vEJm5W3xVy3vG5oSSV8=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    torch
  ];

  optional-dependencies = {
    linear = [
      apache-tvm-ffi
      nvidia-cutlass-dsl
      packaging
    ];
  };

  pythonImportsCheck = [
    "attn_gym"
    "attn_gym.linear"
    "attn_gym.sparse"
  ];

  # Most tests require a GPU
  doCheck = false;

  meta = {
    description = "Helpful tools and examples for working with flex-attention";
    homepage = "https://github.com/meta-pytorch/attention-gym";
    changelog = "https://github.com/meta-pytorch/attention-gym/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
