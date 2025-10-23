{
  buildRedist,
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
    numactl
    rdma-core
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libcuda.so.1"
  ];

  meta = {
    description = "Library to leverage GDS technology";
    homepage = "https://docs.nvidia.com/gpudirect-storage/api-reference-guide";
  };
}
