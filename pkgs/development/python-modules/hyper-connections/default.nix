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
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "hyper-connections";
    tag = finalAttrs.version;
    hash = "sha256-x1Yx9Fnow9154kFGLmjeCBLYJsbv6oJiC6Rk1XudqJQ=";
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
