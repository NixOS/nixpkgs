let
  makePackage = { version, buildNumber, packageType, vmType, sha256 }: import ./jdk-darwin-base.nix {
    name = if packageType == "jdk"
      then
        "adoptopenjdk-${vmType}-bin-${version}"
      else
        "adoptopenjdk-${packageType}-${vmType}-bin-${version}";

    url = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${version}%2B${buildNumber}/OpenJDK11-${packageType}_x64_mac_${vmType}_${version}_${buildNumber}.tar.gz";

    inherit sha256;
  };
in
{
  jdk-hotspot = makePackage {
    version = "11";
    buildNumber = "28";
    packageType = "jdk";
    vmType = "hotspot";
    sha256 = "ca0ec49548c626904061b491cae0a29b9b4b00fb34d8973dc217e10ab21fb0f3";
  };
  jre-hotspot = makePackage {
    version = "11";
    buildNumber = "28";
    packageType = "jre";
    vmType = "hotspot";
    sha256 = "ef4dbfe5aed6ab2278fcc14db6cc73abbaab56e95f6ebb023790a7ebc6d7f30c";
  };
  jdk-openj9 = makePackage {
    version = "11.0.1";
    buildNumber = "13";
    packageType = "jdk";
    vmType = "openj9";
    sha256 = "c5e9b588b4ac5b0bd5b4edd69d59265d1199bb98af7ca3270e119b264ffb6e3f";
  };
  jre-openj9 = makePackage {
    version = "11.0.1";
    buildNumber = "13";
    packageType = "jre";
    vmType = "openj9";
    sha256 = "0901dc5946fdf967f92f7b719ddfffdcdde5bd3fef86a83d7a3f2f39ddbef1f8";
  };
}
