{ fetchMaven }:

rec {
  mavenProject_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-project";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0laxsz9z48zvx27m395djfl9121jkr7amiv8n07z9nkz9i60wjl52bb7cw6hp6090ba098g8azqpnz8l5i0yj255phy1j6s92ci1i7c"; }
    { type = "pom"; sha512 = "047a0a2bd5fkmg70gzhdiwiwq5dmr84pz6jq9yi5fz44y57ndp7nb72fnkr0p0qcwmry3gj03hk9p2xr4ph53bl1x68j22fnv0f9krq"; }
  ];
}
