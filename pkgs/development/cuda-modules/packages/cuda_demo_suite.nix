{
  buildRedist,
  libcufft,
  libcurand,
  libGLU,
  libglut,
  libglvnd,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_demo_suite";

  buildInputs = [
    libcufft
    libcurand
    libGLU
    libglut
    libglvnd
  ];

  outputs = [ "out" ];

  meta = {
    description = "Pre-built applications which use CUDA";
    longDescription = ''
      The CUDA Demo Suite contains pre-built applications which use CUDA. These applications demonstrate the
      capabilities and details of NVIDIA GPUs.
    '';
    homepage = "https://docs.nvidia.com/cuda/demo-suite";
  };
}
