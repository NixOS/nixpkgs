{
  lib,
<<<<<<< HEAD
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  flit-core,

<<<<<<< HEAD
=======
  # dependencies
  sniffio,

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # nativeCheckInputs
  pytestCheckHook,
  imageio,
  glfw,
  numpy,
  trio,
  wgpu-py,
<<<<<<< HEAD
}:
buildPythonPackage rec {
  pname = "rendercanvas";
  version = "2.5.2";
=======

  nix-update-script,
}:
buildPythonPackage rec {
  pname = "rendercanvas";
  version = "2.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pygfx";
    repo = "rendercanvas";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-fOjiGNxEUVI+jddrwqrlBYT+CAMDQCIPNHwGonBH4Hk=";
=======
    hash = "sha256-42jnCD0jSGkz6zLokzF1lXjnVP8E2yrPu8AQ80EKEI4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    rm -r rendercanvas/__pyinstaller
  '';

<<<<<<< HEAD
  env = {
    # This relaxes the timeing assertions thus making the tests less flaky
    CI = "1";
  };

  build-system = [ flit-core ];

=======
  build-system = [ flit-core ];

  dependencies = [ sniffio ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [
    pytestCheckHook
    glfw
    imageio
    numpy
    trio
    # break circular dependency cycle
    (wgpu-py.overrideAttrs { doInstallCheck = false; })
  ];

<<<<<<< HEAD
  disabledTests = [
    # flaky timing and / or interrupt based tests
    "test_offscreen_event_loop"
    "test_call_later_thread"

    # AssertionError
    "test_that_we_are_on_lavapipe"
  ];
=======
  # flaky timing and / or interrupt based tests
  disabledTests = [ "test_offscreen_event_loop" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  disabledTestPaths = [
    "tests/test_loop.py"
    "tests/test_scheduling.py"
  ];

  pythonImportsCheck = [ "rendercanvas" ];

  meta = {
    description = "One canvas API, multiple backends";
    homepage = "https://github.com/pygfx/rendercanvas";
    changelog = "https://github.com/pygfx/rendercanvas/releases/tag/${src.tag}";
<<<<<<< HEAD
=======

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.all;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
