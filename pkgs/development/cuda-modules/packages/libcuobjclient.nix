{
  buildRedist,
  libcufile,
  numactl,
  rdma-core,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcuobjclient";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  buildInputs = [
    libcufile
    numactl
    # NOTE: DT_NEEDED, but until now resolved only because auto-patchelf harvests the runpath of
    # libcufile's libcufile_rdma.so, which happens to point at rdma-core.
    rdma-core # libibverbs.so.1, librdmacm.so.1, libmlx5.so.1
  ];

  meta = {
    description = "CUDA cuObject Client";
    longDescription = ''
      High-performance suite of libraries designed to enable direct data transfers between GPU
      memory or system memory and object storage (S3-compatible) solution via RDMA.
    '';
    homepage = "https://docs.nvidia.com/gpudirect-storage/cuobject/";
    changelog = "https://docs.nvidia.com/gpudirect-storage/cuobject/";
  };
}
