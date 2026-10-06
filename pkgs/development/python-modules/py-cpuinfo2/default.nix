{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-cpuinfo2";
  version = "10.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akx";
    repo = "py-cpuinfo2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7w5d8TEfNeSuS7CSaHolOuHri948v6JccIPtIbQr77o=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cpuinfo" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module for getting CPU info with pure Python";
    homepage = "https://github.com/akx/py-cpuinfo2";
    changelog = "https://github.com/akx/py-cpuinfo2/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
