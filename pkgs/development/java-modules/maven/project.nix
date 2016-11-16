{ fetchMaven }:

rec {
  mavenProject_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-project";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "09dyyxwyjlr9q65r8zh7bsf41glpqxc9b6902s2s1clrs98k672kg04vq4fn569vx6hishna3kpxk8y7q5k5zpfy3g9wqsxcxhbqznx"; }
    { type = "pom"; sha512 = "2fl4dl48cni9hqx0i7arrylcs028vymvmsa0wncbsz37g2gsxq462lqqd1swhgjnjqn1g6386rh6wq6j9mhpbm8kf741aypz9sf33wm"; }
  ];

  mavenProject_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-project";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "12k56956ad8r5fpz5ilxy1i2msg4vnpcyqc7zq9b5ncqx890bcnl9xl5f5y0bkj6l6688z6vrwi28rgj35a77x3wiwcvhgrgxyfy53a"; }
    { type = "pom"; sha512 = "13z607rjazzrs3rjw6hlhpw6jip85lgdkvnkm1j17wsbhywa53x45ydyg1hzrcax8xr5zxn7mkrryp4wwwm4ihhsaz3nq8bh12yrh8p"; }
  ];

  mavenProject_2_0_8 = map (obj: fetchMaven {
    version = "2.0.8";
    artifactId = "maven-project";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2j3mwqh0zjm7pc7jydpdg6xp5gl3ila84zkhk1znn9663d84p4wgkv6zi1r16djc5jvy2g2z2id1zc7gr97spv5riwz3hbw1vw4ajzp"; }
    { type = "pom"; sha512 = "1489hvb5g28afc2yjyc5qnlihg0qqiq0r1fkbl976hvr5kfj6pkx4h3sz69gv3pnsgpjkavqxafm11s7w1hgd8xsvajrnsy77hmpsqa"; }
  ];

  mavenProject_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-project";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0laxsz9z48zvx27m395djfl9121jkr7amiv8n07z9nkz9i60wjl52bb7cw6hp6090ba098g8azqpnz8l5i0yj255phy1j6s92ci1i7c"; }
    { type = "pom"; sha512 = "047a0a2bd5fkmg70gzhdiwiwq5dmr84pz6jq9yi5fz44y57ndp7nb72fnkr0p0qcwmry3gj03hk9p2xr4ph53bl1x68j22fnv0f9krq"; }
  ];

  mavenProject_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-project";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3km1j5jnkyil76817gk37ds8v69fmiz2zh924vnsv8sbaj4bm8rs7n5d5laiyss5ff0p1q9by3k1ai94lw2ambc5pbmm6lz0v71naic"; }
    { type = "pom"; sha512 = "10mk142nqdaq8nqg6sf4wfaq2ymlf3fs2ay8xjrfp07l68z838b2kmj7s8lvv1qzkcnkcjrg9w2kr1m3i8bqxc68fwd5iqdq674c1p3"; }
  ];
}
