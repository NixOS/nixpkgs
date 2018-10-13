let
  version = "11";
  buildNumber = "28";
  baseUrl = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${version}%2B${buildNumber}";
  makePackage = { packageType, vmType, sha256 }: import ./jdk-linux-base.nix {
    name = if packageType == "jdk"
      then
        "adoptopenjdk-${vmType}-bin-${version}"
      else
        "adoptopenjdk-${packageType}-${vmType}-bin-${version}";
    url = "${baseUrl}/OpenJDK${version}-${packageType}_x64_linux_${vmType}_${version}_${buildNumber}.tar.gz";
    inherit sha256;
  };
in
{
  jdk-hotspot = makePackage {
    packageType = "jdk";
    vmType = "hotspot";
    sha256 = "e1e18fc9ce2917473da3e0acb5a771bc651f600c0195a3cb40ef6f22f21660af";
  };
  jre-hotspot = makePackage {
    packageType = "jre";
    vmType = "hotspot";
    sha256 = "346448142d46c6e51d0fadcaadbcde31251d7678922ec3eb010fcb1b6e17804c";
  };
  jdk-openj9 = makePackage {
    packageType = "jdk";
    vmType = "openj9";
    sha256 = "fd77f22eb74078bcf974415abd888296284d2ceb81dbaca6ff32f59416ebc57f";
  };
  jre-openj9 = makePackage {
    packageType = "jre";
    vmType = "openj9";
    sha256 = "83a7c95e6b2150a739bdd5e8a6fe0315904fd13d8867c95db67c0318304a2c42";
  };
}
