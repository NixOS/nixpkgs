{
  buildRedist,
  cuda_cudart,
  lib,
  numactl,
  rdma-core,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcufile";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  allowFHSReferences = true;

  buildInputs = [
    (lib.getOutput "stubs" cuda_cudart)
    numactl
    rdma-core
  ];

  extraAutoPatchelfLibs = [
    "${lib.getOutput "stubs" cuda_cudart}/lib/stubs"
  ];

  meta = {
    description = "Library to leverage GDS technology";
    homepage = "https://docs.nvidia.com/gpudirect-storage/api-reference-guide";
  };
}
