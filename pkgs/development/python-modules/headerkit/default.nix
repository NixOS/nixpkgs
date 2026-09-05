{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  hatchling,

  pythonOlder,
  tomli,

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
  version = "0.37.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "axiomantic";
    repo = "headerkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uCrXvTuzkRqmJCbjCLuGQrdELDcBB2vJwrDlrMMcewM=";
  };

  patches = [
    (replaceVars ./use-system-libclang.patch {
      libclangPath = "${lib.getLib llvmPackages.libclang}/lib/libclang${stdenvNoCC.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ hatchling ];
  dependencies = lib.optional (pythonOlder "3.11") tomli;

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
    "tests/test_cache/test_generate.py"
    "tests/test_integration/test_real_headers.py"
    "tests/test_backends/test_libclang.py::TestLibclangSearchPathsWindows"
    "tests/test_backends/test_libclang.py::TestPipClangNativeSearchPath"
  ];
  disabledTests = [
    "test_generic_lib_versioned_so_paths"
    "test_versioned_so_in_lib64_paths"
  ];

  passthru.optional-dependencies = {
    treesitter = [
      tree-sitter
      tree-sitter-grammars.tree-sitter-c
      tree-sitter-grammars.tree-sitter-cpp
    ];
  };

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
