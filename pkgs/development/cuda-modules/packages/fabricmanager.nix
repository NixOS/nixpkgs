{ buildRedist, zlib }:
buildRedist {
  redistName = "cuda";
  pname = "fabricmanager";

  outputs = [
    "out"
    "bin"
    "dev"
    "include"
    "lib"
  ];

  allowFHSReferences = true;

  buildInputs = [ zlib ];

  meta.homepage = "https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide";
}
