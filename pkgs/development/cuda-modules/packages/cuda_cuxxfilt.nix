{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_cuxxfilt";

  outputs = [
    "out"
    "bin"
    "dev"
    "include"
    "static"
  ];

  meta = {
    description = "Decode low-level identifiers that have been mangled by CUDA C++ into user readable names";
    longDescription = ''
      cu++filt decodes (demangles) low-level identifiers that have been mangled by CUDA C++ into user readable names.
    '';
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#cu-filt";
  };
}
