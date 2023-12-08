# NOTE: Though NCCL is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  lib,
  fetchFromGitHub,
  python3,
  which,
  cudaPackages,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (cudaPackages)
    autoAddOpenGLRunpathHook
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudaFlags
    cudatoolkit
    cudaVersion
    ;
in
backendStdenv.mkDerivation (
  finalAttrs: {
    pname = "nccl";
    version = "2.19.3-1";

    src = fetchFromGitHub {
      owner = "NVIDIA";
      repo = finalAttrs.pname;
      rev = "v${finalAttrs.version}";
      hash = "sha256-59FlOKM5EB5Vkm4dZBRCkn+IgIcdQehE+FyZAdTCT/A=";
    };

    strictDeps = true;

    outputs = [
      "out"
      "dev"
    ];

    nativeBuildInputs =
      [
        which
        autoAddOpenGLRunpathHook
        python3
      ]
      ++ lib.optionals (lib.versionOlder cudaVersion "11.4") [cudatoolkit]
      ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [cuda_nvcc];

    buildInputs =
      lib.optionals (lib.versionOlder cudaVersion "11.4") [cudatoolkit]
      ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [
        cuda_nvcc.dev # crt/host_config.h
        cuda_cudart
      ]
      # NOTE: CUDA versions in Nixpkgs only use a major and minor version. When we do comparisons
      # against other version, like below, it's important that we use the same format. Otherwise,
      # we'll get incorrect results.
      # For example, lib.versionAtLeast "12.0" "12.0.0" == false.
      ++ lib.optionals (lib.versionAtLeast cudaVersion "12.0") [cuda_cccl];

    env.NIX_CFLAGS_COMPILE = toString ["-Wno-unused-function"];

    preConfigure = ''
      patchShebangs ./src/device/generate.py
      makeFlagsArray+=(
        "NVCC_GENCODE=${lib.concatStringsSep " " cudaFlags.gencode}"
      )
    '';

    makeFlags =
      ["PREFIX=$(out)"]
      ++ lib.optionals (lib.versionOlder cudaVersion "11.4") [
        "CUDA_HOME=${cudatoolkit}"
        "CUDA_LIB=${lib.getLib cudatoolkit}/lib"
        "CUDA_INC=${lib.getDev cudatoolkit}/include"
      ]
      ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [
        "CUDA_HOME=${cuda_nvcc}"
        "CUDA_LIB=${lib.getLib cuda_cudart}/lib"
        "CUDA_INC=${lib.getDev cuda_cudart}/include"
      ];

    enableParallelBuilding = true;

    postFixup = ''
      moveToOutput lib/libnccl_static.a $dev
    '';

    passthru.updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };

    meta = with lib; {
      description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
      homepage = "https://developer.nvidia.com/nccl";
      license = licenses.bsd3;
      platforms = platforms.linux;
      maintainers =
        with maintainers;
        [
          mdaiter
          orivej
        ]
        ++ teams.cuda.members;
    };
  }
)
