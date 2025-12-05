{
  buildRedist,
  libcufft,
  libcurand,
  libGLU,
  libglut,
  libglvnd,
  mesa,
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
    mesa
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
