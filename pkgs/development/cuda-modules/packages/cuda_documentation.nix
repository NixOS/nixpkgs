{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_documentation";

  outputs = [ "out" ];

  allowFHSReferences = true;

  meta = {
    homepage = "https://docs.nvidia.com/cuda";
    changelog = "https://docs.nvidia.com/cuda/cuda-toolkit-release-notes";
  };
}
