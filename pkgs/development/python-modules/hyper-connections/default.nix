{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "hyper-connections";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "hyper-connections";
    tag = version;
    hash = "sha256-GRP4ODCs/MMx9S/6LYFMpIoZNJinkcMeY73x4aFacsg=";
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
    changelog = "https://github.com/lucidrains/hyper-connections/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
