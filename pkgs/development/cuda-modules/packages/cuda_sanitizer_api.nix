{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_sanitizer_api";

  outputs = [ "out" ];

  allowFHSReferences = true;

  meta = {
    description = "Enables the creation of sanitizing and tracing tools that target CUDA applications";
    longDescription = ''
      The Compute Sanitizer API enables the creation of sanitizing and tracing tools that target CUDA applications.
      Examples of such tools are memory and race condition checkers.
    '';
    homepage = "https://docs.nvidia.com/compute-sanitizer/SanitizerApiGuide";
  };
}
