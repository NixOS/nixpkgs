{ lib
, backendStdenv
, fetchFromGitHub
, which
<<<<<<< HEAD
, autoAddOpenGLRunpathHook
, cuda_cccl
, cuda_cudart
, cuda_nvcc
, cudaFlags
, cudaVersion
# passthru.updateScript
, gitUpdater
}:
=======
, cudaPackages ? { }
, addOpenGLRunpath
}:

with cudaPackages;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  # Output looks like "-gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_86,code=compute_86"
  gencode = lib.concatStringsSep " " cudaFlags.gencode;
in
<<<<<<< HEAD
backendStdenv.mkDerivation (finalAttrs: {
  pname = "nccl";
  version = "2.18.5-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-vp2WitKateEt1AzSeeEvY/wM4NnUmV7XgL/gfPRUObY=";
=======
backendStdenv.mkDerivation rec {
  name = "nccl-${version}-cuda-${cudaPackages.cudaMajorVersion}";
  version = "2.16.5-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${version}";
    hash = "sha256-JyhhYKSVIqUKIbC1rCJozPT1IrIyRLGrTjdPjJqsYaU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    which
<<<<<<< HEAD
    autoAddOpenGLRunpathHook
=======
    addOpenGLRunpath
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cudart
<<<<<<< HEAD
  ]
  # NOTE: CUDA versions in Nixpkgs only use a major and minor version. When we do comparisons
  # against other version, like below, it's important that we use the same format. Otherwise,
  # we'll get incorrect results.
  # For example, lib.versionAtLeast "12.0" "12.0.0" == false.
  ++ lib.optionals (lib.versionAtLeast cudaVersion "12.0") [
=======
  ] ++ lib.optionals (lib.versionAtLeast cudaVersion "12.0.0") [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cuda_cccl
  ];

  preConfigure = ''
    patchShebangs src/collectives/device/gen_rules.sh
    makeFlagsArray+=(
      "NVCC_GENCODE=${gencode}"
    )
  '';

  makeFlags = [
    "CUDA_HOME=${cuda_nvcc}"
<<<<<<< HEAD
    "CUDA_LIB=${lib.getLib cuda_cudart}/lib"
    "CUDA_INC=${lib.getDev cuda_cudart}/include"
=======
    "CUDA_LIB=${cuda_cudart}/lib64"
    "CUDA_INC=${cuda_cudart}/include"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "PREFIX=$(out)"
  ];

  postFixup = ''
    moveToOutput lib/libnccl_static.a $dev
<<<<<<< HEAD
=======

    # Set RUNPATH so that libnvidia-ml in /run/opengl-driver(-32)/lib can be found.
    # See the explanation in addOpenGLRunpath.
    addOpenGLRunpath $out/lib/lib*.so
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-unused-function" ];

<<<<<<< HEAD
  # Run the update script with: `nix-shell maintainers/scripts/update.nix --argstr package cudaPackages.nccl`
  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  enableParallelBuilding = true;

=======
  enableParallelBuilding = true;

  passthru = {
    inherit cudaPackages;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
    homepage = "https://developer.nvidia.com/nccl";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter orivej ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
