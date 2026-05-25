{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,

  # build-system
  ninja,
  setuptools,

  # dependencies
  iopath,
  torch,

  config,
  cudaSupport ? config.cudaSupport,
}:

assert cudaSupport -> torch.cudaSupport;

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "pytorch3d";
  version = "0.7.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "pytorch3d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k+hqAy0T5ZReJ8jWuKJ/VTzjqd4qo8rrcFo8y4LJhhY=";
  };

  nativeBuildInputs = lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  build-system = [
    ninja
    setuptools
    torch
  ];

  dependencies = [
    iopath
    torch
  ];
  buildInputs = [
    (lib.getOutput "cxxdev" torch)
  ];

  env = {
    FORCE_CUDA = cudaSupport;
  }
  // lib.optionalAttrs cudaSupport {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
  };

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  pythonImportsCheck = [ "pytorch3d" ];

  passthru.tests.rotations-cuda =
    cudaPackages.writeGpuTestPython { libraries = ps: [ ps.pytorch3d ]; }
      ''
        import pytorch3d.transforms as p3dt

        M = p3dt.random_rotations(n=10, device="cuda")
        assert "cuda" in M.device.type
        angles = p3dt.matrix_to_euler_angles(M, "XYZ")
        assert "cuda" in angles.device.type
        assert angles.shape == (10, 3), angles.shape
        print(angles)
      '';

  meta = {
    description = "FAIR's library of reusable components for deep learning with 3D data";
    homepage = "https://github.com/facebookresearch/pytorch3d";
    changelog = "https://github.com/facebookresearch/pytorch3d/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pbsds
      SomeoneSerge
    ];
  };
})
