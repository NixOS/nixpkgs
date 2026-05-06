{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  torch,
  torch-einops-utils,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyper-connections";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "hyper-connections";
    tag = finalAttrs.version;
    hash = "sha256-RDwnRtHUWilyqsDmdiV+kRg7BqTS1yghiu9RAM+MNjE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    einops
    torch
    torch-einops-utils
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyper_connections" ];

  meta = {
    description = "Module to make multiple residual streams";
    homepage = "https://github.com/lucidrains/hyper-connections";
    changelog = "https://github.com/lucidrains/hyper-connections/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
