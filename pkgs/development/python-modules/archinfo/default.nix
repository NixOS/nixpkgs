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
  # Keep angr-management, angr, archinfo, claripy, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "9.3.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "archinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iiclggVwhllM7WNm35/u8zehECXePPXcp0AdmPlyWLo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "archinfo" ];

  meta = {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
