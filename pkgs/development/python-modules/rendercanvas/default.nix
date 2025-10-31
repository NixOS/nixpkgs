{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  sniffio,

  # nativeCheckInputs
  pytestCheckHook,
  imageio,
  glfw,
  numpy,
  trio,
  wgpu-py,

  nix-update-script,
}:
buildPythonPackage rec {
  pname = "rendercanvas";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygfx";
    repo = "rendercanvas";
    tag = "v${version}";
    hash = "sha256-6vvPIu+Zi+9ndcWHP43X0Qd+XCO7+tr8XCFm+bwCazE=";
  };

  postPatch = ''
    rm -r rendercanvas/__pyinstaller
  '';

  build-system = [ flit-core ];

  dependencies = [ sniffio ];

  nativeCheckInputs = [
    pytestCheckHook
    glfw
    imageio
    numpy
    trio
    # break circular dependency cycle
    (wgpu-py.overrideAttrs { doInstallCheck = false; })
  ];

  # flaky timing and / or interrupt based tests
  disabledTests = [ "test_offscreen_event_loop" ];
  disabledTestPaths = [
    "tests/test_loop.py"
    "tests/test_scheduling.py"
  ];

  pythonImportsCheck = [ "rendercanvas" ];

  meta = {
    description = "One canvas API, multiple backends";
    homepage = "https://github.com/pygfx/rendercanvas";
    changelog = "https://github.com/pygfx/rendercanvas/releases/tag/${src.tag}";

    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
