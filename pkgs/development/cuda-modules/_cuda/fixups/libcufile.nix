{
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
}
