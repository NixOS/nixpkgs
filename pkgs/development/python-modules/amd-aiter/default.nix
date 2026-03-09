{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  packaging,
  psutil,
  pybind11,
  einops,
  ninja,
  numpy,
  pandas,
  rocmPackages,
  torch,
  writableTmpDirAsHomeHook,

  gpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,
  # From validate_and_update_archs at https://github.com/ROCm/aiter/blob/main/aiter/jit/core.py
  supportedGpuTargets ? [
    "gfx90a"
    "gfx940"
    "gfx941"
    "gfx942"
    "gfx1100"
    "gfx1101"
    "gfx1102"
    "gfx1103"
    "gfx1150"
    "gfx1151"
    "gfx1152"
    "gfx1153"
    "gfx1200"
    "gfx1201"
    "gfx950"
  ],
}:
buildPythonPackage (finalAttrs: {
  pname = "amd-aiter";
  version = "0.1.11.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aiter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9CCSmEw0kIoxERhtkKhBkaAGx42kCssH7IPjTgbg9LA=";
  };

  postPatch = ''
    rmdir 3rdparty/composable_kernel
    ln -sf ${rocmPackages.composable_kernel.src} 3rdparty/composable_kernel

    # python relax deps hook?
    substituteInPlace pyproject.toml \
      --replace-fail '"flydsl==0.0.1.dev95158637"' ""

    # TODO: upstream fix. get_git_commit_id_short() assumes a git clone;
    # fails in hermetic builds, should fall back gracefully.
    substituteInPlace csrc/cpp_itfs/utils.py \
      --replace-fail \
        'commit_id = get_git_commit_id_short()' \
        'commit_id = "${finalAttrs.version}"'

    # setuptools runs setup.py twice (metadata + wheel). prepare_packaging()
    # copies 3rdparty/ (with nix store read-only files) into aiter_meta/, then
    # the second run can't rmtree or overwrite them.
    substituteInPlace setup.py \
      --replace-fail \
        $'prepare_packaging()\n\n\nclass' \
        $'if not os.path.exists("aiter_meta"): prepare_packaging()\n\n\nclass' \
      --replace-fail \
        'if os.path.exists("aiter_meta") and os.path.isdir("aiter_meta"):' \
        'if False:'
  '';

  env = {
    SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;
    PREBUILD_KERNELS = "0";
    BUILD_TARGET = "rocm";
    ROCM_PATH = "${rocmPackages.clr}";
    # FIXME does it even matter when PREBUILD_KERNELS is off?
    GPU_ARCHS = lib.concatStringsSep ";" (lib.lists.intersectLists gpuTargets supportedGpuTargets);
  };

  build-system = [
    setuptools
    setuptools-scm
    packaging
    psutil
    pybind11
    ninja
    pandas
  ];

  buildInputs = [ rocmPackages.clr ];

  nativeBuildInputs = [
    rocmPackages.hipcc
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "aiter" ];

  dependencies = [
    einops
    ninja
    numpy
    packaging
    pandas
    psutil
    pybind11
    torch
  ];

  # Import requires writable $HOME (JIT cache) and ROCm GPU
  # pythonImportsCheck = [ "aiter" ];

  # Most of the tests require gpu
  doCheck = false;

  meta = {
    description = "AI Tensor Engine for ROCm";
    homepage = "https://github.com/ROCm/aiter";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ lach ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
