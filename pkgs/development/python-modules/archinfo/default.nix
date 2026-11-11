{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "archinfo";
  # Keep angr-management, angr, archinfo, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "10.0.5";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "archinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iM1w+H+MNoWOjSn0ugGztl0Bn2VoxIkasmna9L43KPc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
})
