{
  backendStdenv,
  buildRedist,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_cupti";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "samples"
  ]
  ++ lib.optionals (backendStdenv.hostNixSystem == "x86_64-linux") [ "static" ];

  allowFHSReferences = true;

  meta = {
    description = "C-based interface for creating profiling and tracing tools designed for CUDA applications";
    longDescription = ''
      The CUDA Profiling Tools Interface (CUPTI) provides a C-based interface for creating profiling and tracing tools
      designed for CUDA applications.
    '';
    homepage = "https://docs.nvidia.com/cupti";
    changelog = "https://docs.nvidia.com/cupti/release-notes/release-notes.html";
  };
}
