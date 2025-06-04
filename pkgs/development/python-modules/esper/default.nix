{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "esper";
  version = "3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benmoran56";
    repo = "esper";
    tag = "v${version}";
    hash = "sha256-DZAF2B40ulSn2MQadklT32Svcm1j0e/hIxrxISO07TI=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "esper" ];

  meta = {
    description = "ECS (Entity Component System) for Python";
    homepage = "https://github.com/benmoran56/esper";
    changelog = "https://github.com/benmoran56/esper/blob/${src.rev}/RELEASE_NOTES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
