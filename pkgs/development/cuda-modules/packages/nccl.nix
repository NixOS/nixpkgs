# NOTE: Though NCCL is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  autoAddDriverRunpath,
  cudaAtLeast,
  cudaFlags,
  cudaMajorMinorVersion,
  cudaOlder,
  cudaPackages,
  fetchFromGitHub,
  lib,
  python3,
  which,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudatoolkit
    ;
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) any;
  inherit (lib.trivial) id;
in
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl";
  version = "2.21.5-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-IF2tILwW8XnzSmfn7N1CO7jXL95gUp02guIW5n1eaig=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "dev"
    "static"
  ];

  # brokenConditions :: AttrSet Bool
  # Sets `meta.broken = true` if any of the conditions are true.
  # Example: Broken on a specific version of CUDA or when a dependency has a specific version.
  brokenConditions = {
    "CUDA versions prior to 11.4 cannot build this version of NCCL" = cudaOlder "11.4";
  };

  nativeBuildInputs =
    [
      which
      autoAddDriverRunpath
      python3
    ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [ cuda_nvcc ];

  buildInputs =
    lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [
      cuda_cudart.dev
      cuda_cudart.lib
      cuda_cudart.static
      cuda_nvcc.dev # crt/host_config.h
    ]
    # NOTE: CUDA versions in Nixpkgs only use a major and minor version. When we do comparisons
    # against other version, like below, it's important that we use the same format. Otherwise,
    # we'll get incorrect results.
    # For example, lib.versionAtLeast "12.0" "12.0.0" == false.
    ++ lib.optionals (cudaAtLeast "12.0") [ cuda_cccl.dev ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-unused-function" ];

  postPatch = ''
    patchShebangs ./src/device/generate.py
  '';

  makeFlagsArray =
    [
      "PREFIX=$(out)"
      "NVCC_GENCODE=${cudaFlags.gencodeString}"
    ]
    ++ lib.optionals (cudaOlder "11.4") [
      "CUDA_HOME=${cudatoolkit}"
      "CUDA_LIB=${cudatoolkit}/lib"
      "CUDA_INC=${cudatoolkit}/include"
    ]
    ++ lib.optionals (cudaAtLeast "11.4") [
      "CUDA_HOME=${cuda_nvcc.bin}"
      "CUDA_LIB=${cuda_cudart.lib}/lib"
      "CUDA_INC=${cuda_cudart.dev}/include"
    ];

  enableParallelBuilding = true;

  postFixup = ''
    moveToOutput lib/libnccl_static.a "$static"
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
    broken = any id (attrValues finalAttrs.brokenConditions);
    # NCCL is not supported on Jetson, because it does not use NVLink or PCI-e for inter-GPU communication.
    # https://forums.developer.nvidia.com/t/can-jetson-orin-support-nccl/232845/9
    badPlatforms = lib.optionals cudaFlags.isJetsonBuild [ "aarch64-linux" ];
    maintainers =
      with maintainers;
      [
        mdaiter
        orivej
      ]
      ++ teams.cuda.members;
  };
})
