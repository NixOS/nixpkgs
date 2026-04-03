{ buildRedist, zlib }:
buildRedist {
  redistName = "cuda";
  pname = "imex";

  outputs = [ "out" ];

  allowFHSReferences = true;

  buildInputs = [ zlib ];

  meta = {
    description = "Service which supports GPU memory export and import (NVLink P2P) and shared memory operations across OS domains in an NVLink multi-node deployment";
    homepage = "https://docs.nvidia.com/multi-node-nvlink-systems/imex-guide";
  };
}
