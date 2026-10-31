{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  hatchling,

  pythonOlder,
  tomli,

  pytest,
  pytestCheckHook,
  pytest-timeout,
  pytest-tripwire,
  dirty-equals,

  tree-sitter,
  tree-sitter-grammars,

  llvmPackages,
  writableTmpDirAsHomeHook,
  nim,
}:

buildPythonPackage (finalAttrs: {
  pname = "headerkit";
  version = "0.42.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "axiomantic";
    repo = "headerkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JlwL3RvvqnugeB8oJezxaH1it7CSSfjB99mh/G4KNik=";
  };

  patches = [
    (replaceVars ./use-system-libclang.patch {
      libclangPath = "${lib.getLib llvmPackages.libclang}/lib/libclang${stdenvNoCC.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ hatchling ];
  dependencies = lib.optional (pythonOlder "3.11") tomli ++ [
    pytest
  ];

  optional-dependencies = {
    treesitter = [
      tree-sitter
      tree-sitter-grammars.tree-sitter-c
      tree-sitter-grammars.tree-sitter-cpp
    ];
  };

  pythonImportsCheck = [ "headerkit" ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    pytest-tripwire
    dirty-equals
    llvmPackages.clang
    writableTmpDirAsHomeHook
    nim
  ]
  ++ lib.flatten (lib.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    "tests/test_backends/test_libclang.py::TestLinuxVersionedSearchPaths"
    "tests/test_backends/test_libclang.py::TestLibclangSearchPathsWindows"
    "tests/test_backends/test_libclang.py::TestPipClangNativeSearchPath"
  ];
  disabledTests = [
    "test_generated_tests_pass_against_the_real_library"
    "test_generated_tripwire_fails_when_the_native_library_is_absent"
    "test_generated_python_suite_executes_against_a_real_library"
  ];

  meta = {
    description = "C/C++ header parsing toolkit with pluggable backends and writers";
    homepage = "https://github.com/axiomantic/headerkit";
    changelog = "https://github.com/axiomantic/headerkit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license =
      with lib.licenses;
      AND [
        mit
        (WITH asl20 llvm-exception)
      ];
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
