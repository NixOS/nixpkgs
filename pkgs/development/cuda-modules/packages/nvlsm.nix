{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "nvlsm";

  outputs = [ "out" ];

  allowFHSReferences = true;

  meta = {
    description = "NVIDIA NVLSM (NVLink Subnet Manager) for 4th-generation NVSwitch management";
    longDescription = ''
      NVLSM is the NVLink Subnet Manager component used on systems with 4th-generation NVSwitch
      silicon (e.g. B200 SXM). It manages the NVLink fabric topology, routing, and quality of
      service between GPUs and NVSwitches. It is typically started before nvidia-fabricmanager,
      which uses the management GUID discovered by NVLSM.
    '';
    homepage = "https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide";
  };
}
