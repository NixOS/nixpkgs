{ lib, stdenv, fetchFromGitHub, which, cudatoolkit, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  name = "nccl-${version}-cuda-${cudatoolkit.majorVersion}";
  version = "2.7.8-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${version}";
    sha256 = "0xxiwaw239dc9g015fka3k1nvm5zyl00dzgxnwzkang61dys9wln";
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

  NIX_CFLAGS_COMPILE = [ "-Wno-unused-function" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
    homepage = "https://developer.nvidia.com/nccl";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter orivej ];
  };
}
