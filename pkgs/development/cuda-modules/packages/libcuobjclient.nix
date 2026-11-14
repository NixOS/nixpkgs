{
  buildRedist,
  cudaAtLeast,
  cudaMajorMinorVersion,
  lib,
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
    numactl
    # NOTE: DT_NEEDED, but until now resolved only because auto-patchelf harvests the runpath of
    # libcufile's libcufile_rdma.so, which happens to point at rdma-core.
    rdma-core # libibverbs.so.1, librdmacm.so.1, libmlx5.so.1
  ];

  # cuobjclient.h includes cufile.h and exposes its types in the public API.
  # CUDA 13.4 also exposes infiniband/verbs.h through cuobjextrc_types.h.
  propagatedBuildInputs = [ libcufile ] ++ lib.optionals (cudaAtLeast "13.4") [ rdma-core ];

  postPatch = ''
    substituteInPlace share/pkgconfig/cuobjclient-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Cflags:' $'Requires: cufile-${cudaMajorMinorVersion}${lib.optionalString (cudaAtLeast "13.4") " libibverbs"}\nCflags:'
  '';

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
