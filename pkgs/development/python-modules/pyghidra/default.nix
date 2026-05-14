{
  lib,
  buildPythonPackage,
  fetchPypi,
  jpype1,
  packaging,
  pytest-datadir,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyghidra";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IQasEx65pJkKee6E3C05p5LPey0N5eqvGw5tfS0pC7Y=";
  };

  pythonRelaxDeps = [ "jpype1" ];

  build-system = [ setuptools ];

  dependencies = [
    jpype1
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-datadir
  ];

  pythonImportsCheck = [ "pyghidra" ];

  disabledTests = [
    # Tests require a Ghidra instance
    "test_import_ghidra_base_java_packages"
    "test_import_script"
    "test_invalid_jpype_keyword_arg"
    "test_invalid_loader_type"
    "test_invalid_vm_arg_succeed"
    "test_loader"
    "test_no_compiler"
    "test_no_language_with_compiler"
    "test_no_program"
    "test_no_project"
    "test_open_program"
    "test_run_script"
  ];

  meta = {
    description = "Native CPython for Ghidra";
    homepage = "https://pypi.org/project/pyghidra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
