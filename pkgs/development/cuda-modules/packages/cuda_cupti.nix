{
  backendStdenv,
  buildRedist,
  lib,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_cupti";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "samples"
  ]
  # NOTE: declaring an output with nothing to move into it is a build failure, and which redist
  # systems ship static archives has changed over time: linux-x86_64 always has, linux-sbsa only
  # since 12.6.37, and linux-aarch64 (Jetson) and linux-ppc64le never have.
  ++ lib.optionals (
    backendStdenv.hostRedistSystem == "linux-x86_64"
    || (backendStdenv.hostRedistSystem == "linux-sbsa" && lib.versionAtLeast finalAttrs.version "12.6")
  ) [ "static" ];

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
})
