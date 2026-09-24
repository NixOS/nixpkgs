{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvfatbin";

  outputs = [ "out" ];

  # Includes stubs.
  includeRemoveStubsFromRunpathHook = true;

  meta = {
    description = "APIs which can be used at runtime to combine multiple CUDA objects into one CUDA fat binary (fatbin)";
    homepage = "https://docs.nvidia.com/cuda/nvfatbin";
  };
}
