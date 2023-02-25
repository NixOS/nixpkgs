{ lib, stdenv, fetchFromGitHub, which, cudaPackages, addOpenGLRunpath }:

with cudaPackages;

stdenv.mkDerivation rec {
  name = "nccl-${version}-cuda-${cudaPackages.cudaMajorVersion}";
  version = "2.16.5-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${version}";
    hash = "sha256-JyhhYKSVIqUKIbC1rCJozPT1IrIyRLGrTjdPjJqsYaU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    which
    addOpenGLRunpath
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cudart
  ];

  preConfigure = ''
    patchShebangs src/collectives/device/gen_rules.sh
  ''
  # We need NVCC to use a compatible backend compiler (we maintain a link to
  # that in `cudatoolkit.cc`). We ship NVCC with a setup-hook that *prepends*
  # the correct -ccbin to nvcc flags. NCCL's Makefile, however, appends another
  # -ccbin, which points at the host platform's compiler, coming from the
  # `stdenv`. Confer
  # https://github.com/NVIDIA/nccl/blob/f3d51667838f7542df8ea32ea4e144d812b3ed7c/makefiles/common.mk#L65
  # Since NVCC will use the last -ccbin on the command-line, we append the correct path again.
  # We hope it's a temporary solution
  + ''
    export NVCC_APPEND_FLAGS+=' --compiler-bindir=${cudatoolkit.cc}/bin'
  '';

  makeFlags = [
    "CUDA_HOME=${cuda_nvcc}"
    "CUDA_LIB=${cuda_cudart}/lib64"
    "CUDA_INC=${cuda_cudart}/include"
    "PREFIX=$(out)"
  ];

  postFixup = ''
    moveToOutput lib/libnccl_static.a $dev

    # Set RUNPATH so that libnvidia-ml in /run/opengl-driver(-32)/lib can be found.
    # See the explanation in addOpenGLRunpath.
    addOpenGLRunpath $out/lib/lib*.so
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-unused-function" ];

  enableParallelBuilding = true;

  passthru = {
    inherit cudaPackages;
  };

  meta = with lib; {
    description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
    homepage = "https://developer.nvidia.com/nccl";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter orivej ];
  };
}
