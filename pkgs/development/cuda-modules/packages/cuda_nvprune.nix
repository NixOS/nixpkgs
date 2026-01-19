{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvprune";

  outputs = [ "out" ];

  meta = {
    description = "Prune host object files and libraries to only contain device code for the specified targets";
    longDescription = ''
      `nvprune` prunes host object files and libraries to only contain device code for the specified targets.
    '';
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#nvprune";
  };
}
