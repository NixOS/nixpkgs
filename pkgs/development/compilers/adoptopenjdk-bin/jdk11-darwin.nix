let
  version = "11";
  buildNumber = "28";
  baseUrl = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${version}%2B${buildNumber}";
  makePackage = { packageType, vmType, sha256 }: import ./jdk-darwin-base.nix {
    name = if packageType == "jdk"
      then
        "adoptopenjdk-${vmType}-bin-${version}"
      else
        "adoptopenjdk-${packageType}-${vmType}-bin-${version}";
    url = "${baseUrl}/OpenJDK${version}-${packageType}_x64_mac_${vmType}_${version}_${buildNumber}.tar.gz";
    inherit sha256;
  };
in
{
  jdk-hotspot = makePackage {
    packageType = "jdk";
    vmType = "hotspot";
    sha256 = "ca0ec49548c626904061b491cae0a29b9b4b00fb34d8973dc217e10ab21fb0f3";
  };
  jre-hotspot = makePackage {
    packageType = "jre";
    vmType = "hotspot";
    sha256 = "ef4dbfe5aed6ab2278fcc14db6cc73abbaab56e95f6ebb023790a7ebc6d7f30c";
  };
}
