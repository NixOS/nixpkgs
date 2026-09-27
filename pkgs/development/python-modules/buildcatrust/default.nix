{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "buildcatrust";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-I7f2LCQ8dGFOX/d04mOUll7IL7y5Qn1EPu9UO5496So=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Non-hermetic, needs internet access (e.g. attempts to retrieve NSS store).
    "buildcatrust/tests/test_nonhermetic.py"
  ];

  pythonImportsCheck = [
    "buildcatrust"
    "buildcatrust.cli"
  ];

  meta = {
    description = "Build SSL/TLS trust stores";
    mainProgram = "buildcatrust";
    homepage = "https://github.com/lukegb/buildcatrust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
  };
})
