{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "esper";
  version = "3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benmoran56";
    repo = "esper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DX1Q8MZ0k9a2PBFqjZJyK/CV4zGB8mttfqspgPYKnu0=";
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
