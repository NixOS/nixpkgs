{ fetchMaven }:

rec {
  mavenProject_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-project";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "12k56956ad8r5fpz5ilxy1i2msg4vnpcyqc7zq9b5ncqx890bcnl9xl5f5y0bkj6l6688z6vrwi28rgj35a77x3wiwcvhgrgxyfy53a"; }
    { type = "pom"; sha512 = "13z607rjazzrs3rjw6hlhpw6jip85lgdkvnkm1j17wsbhywa53x45ydyg1hzrcax8xr5zxn7mkrryp4wwwm4ihhsaz3nq8bh12yrh8p"; }
  ];

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
