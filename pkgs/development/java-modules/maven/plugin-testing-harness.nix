{ fetchMaven }:

rec {
  mavenPluginTestingHarness_1_1 = map (obj: fetchMaven {
    version = "1.1";
    artifactId = "maven-plugin-testing-harness";
    groupId = "org.apache.maven.shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "38cqg736n2nlzhssabyw47yl0rqcaha3k8sqgjs7pgvcpphapxinx9gck2n2y5m77rhjwkz0n6lyym6zi2k382jbasm2n59y5gkpnkj"; }
    { type = "pom"; sha512 = "26gfh7i9qg79yggsp3sl21qj9s4j6hdabllvbvnnr0m6j8whadzbhfx2ds7p6ddvzvyi5214xrsl6ag3nxw6k5rjw10k4g32b0nyvv2"; }
  ];
}
