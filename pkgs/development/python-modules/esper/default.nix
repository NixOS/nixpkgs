{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "esper";
  version = "3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benmoran56";
    repo = "esper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dOeF1CyWcR1wLjO0rTjBq6piJN8QXae4dBK4akdQIjk=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "esper" ];

  meta = {
    description = "ECS (Entity Component System) for Python";
    homepage = "https://github.com/benmoran56/esper";
    changelog = "https://github.com/benmoran56/esper/blob/${finalAttrs.src.tag}/RELEASE_NOTES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
