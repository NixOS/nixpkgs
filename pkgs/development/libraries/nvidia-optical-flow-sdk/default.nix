{ lib, stdenv, fetchFromGitHub, cudaPackages }:

stdenv.mkDerivation {
  pname = "nvidia-optical-flow-sdk";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "NVIDIAOpticalFlowSDK";
    rev = "edb50da3cf849840d680249aa6dbef248ebce2ca";
    sha256 = "0hv0m0k9wl2wjhhl886j7ymngnf2xz7851nfh57s1gy5bv9lgdgz";
  };

  # # We only need the header files. The library files are
  # # in the nvidia_x11 driver.
  installPhase = ''
    mkdir -p $out/include
    cp -R * $out/include
  '';

  # Makes setupCudaHook propagate nvidia-optical-flow-sdk together with cuda
  # packages. Currently used by opencv4.cxxdev, hopefully can be removed in the
  # future
  nativeBuildInputs = [
    cudaPackages.markForCudatoolkitRootHook
  ];

  meta = with lib; {
    description = "Nvidia optical flow headers for computing the relative motion of pixels between images";
    homepage = "https://developer.nvidia.com/opticalflow-sdk";
    license = licenses.bsd3; # applies to the header files only
    platforms = platforms.all;
  };
}
