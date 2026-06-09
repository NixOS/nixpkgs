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
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netdevops";
    repo = "hier_config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMX66ffIPuWkjVEL8fe6E7WCVF+J9+suh5TsQW5e7IY=";
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
    changelog = "https://github.com/netdevops/hier_config/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
