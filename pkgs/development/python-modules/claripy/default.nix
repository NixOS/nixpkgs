{
  lib,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  z3-solver,
}:

buildPythonPackage (finalAttrs: {
  pname = "claripy";
  # Keep angr-management, angr, archinfo, claripy, cle, and pyvex in sync.
  # nixpkgs-update: no auto update
  version = "9.3.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XhLqM9PkysJ+gS21ZDLLumaK2TgC/4k8e0BulPWWoVA=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    cachetools
    z3-solver
  ]
  ++ z3-solver.requiredPythonModules;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "claripy" ];

  meta = {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
