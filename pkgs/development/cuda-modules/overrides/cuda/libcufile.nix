{
  cudaOlder,
  lib,
  libcublas,
  numactl,
  rdma-core,
}:
prevAttrs: {
  allowFHSReferences = true;
  buildInputs = prevAttrs.buildInputs ++ [
    libcublas.lib
    numactl
    rdma-core
  ];
  # Before 11.7 libcufile depends on itself for some reason.
  autoPatchelfIgnoreMissingDeps =
    prevAttrs.autoPatchelfIgnoreMissingDeps
    ++ lib.lists.optionals (cudaOlder "11.7") [ "libcufile.so.0" ];
}
