{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvtx";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  meta = {
    description = "C-based Application Programming Interface (API) for annotating events, code ranges, and resources in your applications";
    longDescription = ''
      NVTX is a cross-platform API for annotating source code to provide contextual information to developer tools.

      The NVTX API is written in C, with wrappers provided for C++ and Python.
    '';
    homepage = "https://github.com/NVIDIA/NVTX";
    changelog = "https://github.com/NVIDIA/NVTX/releases";
  };
}
