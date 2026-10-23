{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvvp";

  outputs = [ "out" ];

  allowFHSReferences = true;

  meta = {
    description = "Cross-platform performance profiling tool for optimizing CUDA C/C++ applications";
    longDescription = ''
      The NVIDIA Visual Profiler is a cross-platform performance profiling tool that delivers developers vital
      feedback for optimizing CUDA C/C++ applications.
    '';
    homepage = "https://developer.nvidia.com/nvidia-visual-profiler";
  };
}
