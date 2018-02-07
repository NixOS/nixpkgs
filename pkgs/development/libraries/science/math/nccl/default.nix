{ stdenv, fetchFromGitHub
, gcc5, eject, cudatoolkit
}:

stdenv.mkDerivation rec {
  name = "cudatoolkit-${cudatoolkit.majorVersion}-nccl-${version}";
  version = "1.3.4-1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "v${version}";
    sha256 = "0fvnrfn572lc6i2a3xyhbifm53ivcrr46z6cqr3b0bwb1iq79m7q";
  };

  nativeBuildInputs = [
    gcc5
    eject
  ];

  propagatedBuildInputs = [
    cudatoolkit
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CUDA_HOME=${cudatoolkit}"
    "CUDA_LIB=${cudatoolkit.lib}/lib"
  ];

  meta = with stdenv.lib; {
    description = ''
      NVIDIA Collective Communications Library.
      Multi-GPU and multi-node collective communication primitives.
    '';
    homepage = https://developer.nvidia.com/nccl;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
