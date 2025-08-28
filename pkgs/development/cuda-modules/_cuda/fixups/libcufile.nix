{
  cuda_cudart,
  lib,
  numactl,
  rdma-core,
}:
prevAttrs: {
  allowFHSReferences = true;

  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    (lib.getOutput "stubs" cuda_cudart)
    numactl
    rdma-core
  ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Library to leverage GDS technology";
    homepage = "https://docs.nvidia.com/gpudirect-storage/api-reference-guide";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libcufile";
  };
}
