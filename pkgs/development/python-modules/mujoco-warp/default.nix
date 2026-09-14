{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  absl-py,
  etils,
  mujoco,
  numpy,
  warp-lang,
  jax,
  lsprotocol,
  mjviser,
  pillow,
  pre-commit,
  pygls,
  pytest,
  pytest-xdist,
  ruff,
  nix-update-script,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mujoco-warp";
  version = "3.11.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco_warp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g5GuGRkBJ3pTRgpzyEI/skB164XeL/ZOdceGPO/hw8M=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    etils
    mujoco
    numpy
    warp-lang
  ];

  optional-dependencies = {
    cpu = [
      jax
    ];
    cuda = [
      jax
    ];
    dev = [
      lsprotocol
      mjviser
      mujoco
      pillow
      pre-commit
      pygls
      pytest
      pytest-xdist
      ruff
      warp-lang
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "mujoco_warp"
  ];

  disabledTests = [
    # XML Error: plugin mujoco.sdf.nut not found
    "test_make_put_data_dims_match1"
    "test_put_data_nworld_array1"
    "test_types_match_annotations1"
  ];

  disabledTestPaths = [
    # XML Error: plugin mujoco.sdf.nut not found
    "mujoco_warp/_src/collision_driver_test.py"
    "mujoco_warp/_src/io_test.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GPU-optimized version of the MuJoCo physics simulator, designed for NVIDIA hardware";
    homepage = "https://github.com/google-deepmind/mujoco_warp";
    changelog = "https://github.com/google-deepmind/mujoco_warp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
