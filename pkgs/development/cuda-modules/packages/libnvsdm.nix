{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvsdm";

  outputs = [
    "out"
    "lib"
  ];

  allowFHSReferences = true;

  meta = {
    description = "NVIDIA NVSwitch Device Manager library";
    homepage = "https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide";
  };
}
