{
  buildRedist,
  libcufile,
  numactl,
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
