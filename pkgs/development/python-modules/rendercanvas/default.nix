{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  flit-core,

  # nativeCheckInputs
  pytestCheckHook,
  imageio,
  glfw,
  numpy,
  trio,
  wgpu-py,
}:
buildPythonPackage rec {
  pname = "rendercanvas";
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygfx";
    repo = "rendercanvas";
    tag = "v${version}";
    hash = "sha256-fOjiGNxEUVI+jddrwqrlBYT+CAMDQCIPNHwGonBH4Hk=";
  };

  postPatch = ''
    rm -r rendercanvas/__pyinstaller
  '';

  env = {
    # This relaxes the timeing assertions thus making the tests less flaky
    CI = "1";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    glfw
    imageio
    numpy
    trio
    # break circular dependency cycle
    (wgpu-py.overrideAttrs { doInstallCheck = false; })
  ];

  disabledTests = [
    # flaky timing and / or interrupt based tests
    "test_offscreen_event_loop"
    "test_call_later_thread"

    # AssertionError
    "test_that_we_are_on_lavapipe"
  ];
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
