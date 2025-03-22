{
  lib,
  buildPythonPackage,
  cachetools,
  decorator,
  fetchFromGitHub,
  pysmt,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  z3-solver,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.147";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    tag = "v${version}";
    hash = "sha256-Ml7BPlx4TT/jPXE0TRp2GeghB68AsanitsjD7lmEphk=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    cachetools
    decorator
    pysmt
    typing-extensions
    z3-solver
  ] ++ z3-solver.requiredPythonModules;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "claripy" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
