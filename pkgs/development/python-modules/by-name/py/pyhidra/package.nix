{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jpype1,
  pytest-datadir,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhidra";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dod-cyber-crime-center";
    repo = "pyhidra";
    tag = version;
    hash = "sha256-8xouU+S7Apy1ySIlvOLPerTApqKy/MNdl9vuBdt+9Vk=";
  };

  build-system = [ setuptools ];

  dependencies = [ jpype1 ];

  nativeCheckInputs = [
    pytest-datadir
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhidra" ];

  disabledTests = [
    # Tests require a running Ghidra instance
    "test_invalid_jpype_keyword_arg"
    "test_invalid_vm_arg_succeed"
    "test_run_script"
    "test_open_program"
    "test_no_compiler"
    "test_no_language_with_compiler"
    "test_loader"
    "test_invalid_loader_type"
    "test_no_project"
    "test_no_program"
    "test_import_script"
    "test_import_ghidra_base_java_packages"
  ];

  meta = {
    description = "Provides direct access to the Ghidra API within a native CPython interpreter using jpype";
    homepage = "https://github.com/dod-cyber-crime-center/pyhidra";
    changelog = "https://github.com/dod-cyber-crime-center/pyhidra/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
