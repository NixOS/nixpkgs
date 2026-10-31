{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvidia_nscq";

  outputs = [
    "out"
    "lib"
  ];

  allowFHSReferences = true;

  meta = {
    description = "NVIDIA NSCQ (Node Scalable Coherency Quantum) API for NVSwitch communication";
    homepage = "https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide";
  };
}
