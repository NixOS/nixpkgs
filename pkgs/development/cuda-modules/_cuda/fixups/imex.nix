{ zlib }:
prevAttrs: {
  allowFHSReferences = true;

  buildInputs = prevAttrs.buildInputs or [ ] ++ [ zlib ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Service which supports GPU memory export and import (NVLink P2P) and shared memory operations across OS domains in an NVLink multi-node deployment";
    homepage = "https://docs.nvidia.com/multi-node-nvlink-systems/imex-guide";
  };
}
