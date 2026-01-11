{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyper-connections";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "hyper-connections";
    tag = finalAttrs.version;
    hash = "sha256-nMNAuHOLOgrWNrMFko5ARBOyp9TyUhJfldPihV012K4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    einops
    torch
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
