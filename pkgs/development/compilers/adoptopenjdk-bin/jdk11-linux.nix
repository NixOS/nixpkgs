let
  makePackage = { version, buildNumber, packageType, vmType, sha256 }: import ./jdk-linux-base.nix {
    name = if packageType == "jdk"
      then
        "adoptopenjdk-${vmType}-bin-${version}"
      else
        "adoptopenjdk-${packageType}-${vmType}-bin-${version}";

    url = "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${version}%2B${buildNumber}/OpenJDK11-${packageType}_x64_linux_${vmType}_${version}_${buildNumber}.tar.gz";

    inherit sha256;
  };
in
{
  jdk-hotspot = makePackage {
    version = "11";
    buildNumber = "28";
    packageType = "jdk";
    vmType = "hotspot";
    sha256 = "e1e18fc9ce2917473da3e0acb5a771bc651f600c0195a3cb40ef6f22f21660af";
  };
  jre-hotspot = makePackage {
    version = "11";
    buildNumber = "28";
    packageType = "jre";
    vmType = "hotspot";
    sha256 = "346448142d46c6e51d0fadcaadbcde31251d7678922ec3eb010fcb1b6e17804c";
  };
  jdk-openj9 = makePackage {
    version = "11.0.1";
    buildNumber = "13";
    packageType = "jdk";
    vmType = "openj9";
    sha256 = "765947ab9457a29d2aa9d11460a4849611343c1e0ea3b33b9c08409cd4672251";
  };
  jre-openj9 = makePackage {
    version = "11.0.1";
    buildNumber = "13";
    packageType = "jre";
    vmType = "openj9";
    sha256 = "a016413fd8415429b42e543fed7a1bee5010b1dbaf71d29a26e1c699f334c6ff";
  };
}
