{ stdenv, fetchFromGitHub, which, cudatoolkit }:

stdenv.mkDerivation rec {
  name = "nccl-${version}-cuda-${cudatoolkit.majorVersion}";
  version = "2.4.2-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${version}";
    sha256 = "0aa4gv51nbmmdhx6vp40l249m4arp30sijrn6kwxdfi1k9kajiq5";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ which ];

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
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-unused-function" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Multi-GPU and multi-node collective communication primitives for NVIDIA GPUs";
    homepage = https://developer.nvidia.com/nccl;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter orivej ];
  };
}
