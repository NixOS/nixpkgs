{
  cudaOlder,
  lib,
  libcublas,
  numactl,
  rdma-core,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    libcublas
    numactl
    rdma-core
  ];
  # Before 11.7 libcufile depends on itself for some reason.
  autoPatchelfIgnoreMissingDeps =
    prevAttrs.autoPatchelfIgnoreMissingDeps or [ ]
    ++ lib.lists.optionals (cudaOlder "11.7") [ "libcufile.so.0" ];
}
