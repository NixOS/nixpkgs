{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  astor,
  dill,
  filelock,

  # tests
  pytestCheckHook,
  torch,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "depyf";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thuml";
    repo = "depyf";
    tag = "v${version}";
    hash = "sha256-GFNlJeD7Nyxr7Ya3aSA6+0AZJSaeDyqXYPEsvhPN1wg=";
  };

  # don't try to read git commit
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'commit_id = get_git_commit_id()' 'commit_id = None'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    astor
    dill
    filelock
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  disabledTestPaths = [
    #     if self.quitting: raise BdbQuit
    # E   bdb.BdbQuit
    "tests/test_pytorch/test_pytorch.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [

    # depyf.decompiler.DecompilationError: DecompilationError: Failed to decompile instruction ...
    # NotImplementedError: Unsupported instruction: LOAD_FAST_LOAD_FAST
    "tests/test_code_owner.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # E   torch._dynamo.exc.BackendCompilerFailed: backend='inductor' raised:
    # E   CppCompileError: C++ compile error
    "tests/test_pytorch/test_export.py"
    "tests/test_pytorch/test_logging.py"
    "tests/test_pytorch/test_simple_graph.py"
  ];

  # All remaining tests fail with:
  # ValueError: invalid literal for int() with base 10: 'L1'
  doCheck = !(pythonAtLeast "3.13");

  pythonImportsCheck = [ "depyf" ];

  meta = {
    description = "Decompile python functions, from bytecode to source code";
    homepage = "https://github.com/thuml/depyf";
    changelog = "https://github.com/thuml/depyf/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
