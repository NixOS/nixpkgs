{
  lib,
  buildPythonPackage,
  cmake,
  cython,
  distutils,
  fetchFromGitHub,
  greenlet,
  ipython,
  jinja2,
  ninja,
  pkg-config,
  pkgconfig,
  pkgs,
  pytest-cov-stub,
  pytest-textual-snapshot,
  pytestCheckHook,
  pythonOlder,
  rich,
  scikit-build-core,
  setuptools,
  stdenv,
  textual,
}:

buildPythonPackage (finalAttrs: {
  pname = "memray";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vllaJazm4sdQaJKd3FxiLl5JO8yWKvQnW2Lajhld37c=";
  };

  patches = [
    # https://github.com/bloomberg/memray/issues/1081
    ./sys-path-site-packaegs.patch
  ];

  build-system = [
    cmake
    distutils
    ninja
    setuptools
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cython
    pkgs.libunwind
    pkgs.lz4
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkgs.elfutils # for `-ldebuginfod`
  ];

  dependencies = [
    pkgconfig
    textual
    jinja2
    rich
  ];

  nativeCheckInputs = [
    ipython
    pytest-cov-stub
    pytest-textual-snapshot
    pytestCheckHook
  ]
  ++ lib.optionals (pythonOlder "3.14") [ greenlet ];

  pythonImportsCheck = [ "memray" ];

  disabledTests = [
    # Import issue
    "test_header_allocator"
    "test_hybrid_stack_of_allocations_inside_ceval"

    # The following snapshot tests started failing since updating textual to 3.5.0
    "TestTUILooks"
    "test_merge_threads"
    "test_tui_basic"
    "test_tui_gradient"
    "test_tui_pause"
    "test_unmerge_threads"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "memray";
  };
})
