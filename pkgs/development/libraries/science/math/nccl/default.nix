{ lib, stdenv, fetchFromGitHub, which, cudaPackages, addOpenGLRunpath }:

let
  inherit (cudaPackages) cudatoolkit;
in

stdenv.mkDerivation rec {
  name = "nccl-${version}-cuda-${cudatoolkit.majorVersion}";
  version = "2.16.5-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${version}";
    hash = "sha256-JyhhYKSVIqUKIbC1rCJozPT1IrIyRLGrTjdPjJqsYaU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ which addOpenGLRunpath ];

  buildInputs = [ cudatoolkit ];

  preConfigure = ''
    patchShebangs src/collectives/device/gen_rules.sh
  '';

  makeFlags = [
    "CUDA_HOME=${cudatoolkit}"
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
