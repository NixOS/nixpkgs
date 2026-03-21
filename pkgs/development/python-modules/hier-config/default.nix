{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "hier-config";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netdevops";
    repo = "hier_config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1E/eWODD4ESmQIZJEvFbeIa0w49i/bcPQSmxriT/m7k=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "hier_config" ];

  meta = {
    description = "Module to handle hierarchical configurations";
    homepage = "https://github.com/netdevops/hier_config";
    changelog = "https://github.com/netdevops/hier_config/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
