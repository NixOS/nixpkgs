{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  imageio-ffmpeg,
  mediapy,
  mjviser,
  mujoco,
  mujoco-warp,
  numpy,
  onnxscript,
  prettytable,
  rsl-rl-lib,
  scipy,
  tensorboard,
  tensordict,
  torch,
  torchrunx,
  tqdm,
  trimesh,
  tyro,
  viser,
  wandb,
  warp-lang,
  nix-update-script,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mjlab";
  version = "1.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mujocolab";
    repo = "mjlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nB+FopWsK7Q7g6Ygv0prInvrLfVHx1qK+FLFZQyo/HE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"uv_build>=' '"uv_build"] #'
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    imageio-ffmpeg
    mediapy
    mjviser
    mujoco
    mujoco-warp
    numpy
    onnxscript
    prettytable
    rsl-rl-lib
    scipy
    tensorboard
    tensordict
    torch
    torchrunx
    tqdm
    trimesh
    tyro
    viser
    wandb
    warp-lang
  ];

  optional-dependencies = {
    cpu = [
      torch
    ];
    cu128 = [
      torch
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # everything segfault when triton llvm and warp-lang llvm are together
  preInstallCheck = ''
    export PYTHONPATH=$(echo "$PYTHONPATH" | tr ':' '\n' | grep -v 'triton' | tr '\n' ':')
  '';

  disabledTests = [
    # https://github.com/google/mediapy/pull/88 + something else wrong in mediapy API
    "test_step_trigger_writes_video"
  ];

  pythonImportsCheck = [
    "mjlab"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Isaac Lab API, powered by MuJoCo-Warp, for RL and robotics research";
    homepage = "https://github.com/mujocolab/mjlab";
    changelog = "https://github.com/mujocolab/mjlab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
