{ fetchMaven }:

rec {
  mavenProfile_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-profile";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "39zjz3jh5q5k4ryyg8psj741gwy01blflmw2hk9krqid9fpmbbcj5f3h34i1q03qcz7kgb1sz1kp58j2fmbk8364y2i0xyrg4zalzz5"; }
    { type = "pom"; sha512 = "32jcvvf47if22cy3z0ld2gf7873ysz4qcx6b2zp62r8pbmj1i2a1kd62llvjv7p2x5l960ndvlr1a80x6mm9mnsjrwxd4vy0iwyshmv"; }
  ];

  mavenProfile_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-profile";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3wng0csnn4v3y2gndazg46hqriz27kkb977xzw5wr8anyharlz2ancl38zyfjf5vm18irqn8cxqklhzd3x1h0h6rlvz5z1wrrivr5kl"; }
    { type = "pom"; sha512 = "063vbh2miyfvrp90hs5cff5r8cj573zysjvd79lnz7zsah3ddbg6sbv09nb0pjy76pbqgrh913dziqk12l13kwngcgpq8v38v92vh63"; }
  ];

  mavenProfile_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-profile";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2v315cv62k3lmi23msk5rj9bijsafcajw7053jdzzk4zv03vdpdndm5cr995azrpdcvkcdq2m8zh5pdf44nzcdf2rvpm4nxdc2wr5rl"; }
    { type = "pom"; sha512 = "05iif04frjgbmg7zb3jygn9av2ja48vs2z35b2zrlmgf3s1fxqlr4wxylrrmmk8r0hvg4qmg5j0inm414n0v4ipn08hrpzik5nhdfgy"; }
  ];

  mavenProfile_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-profile";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "13lgj34xf9wgwx87z5gbqmq3f3l2dqprk68ji1vig49k2ngxfa8xz3a8qh7gbl9l234gkbdl3dcsafr158bi0m3n5myrczbz0wfcia7"; }
    { type = "pom"; sha512 = "0m6fqn507a36rpk0bzwv2zzl1gngcf3h4lrbw8abkmyq7npaqcg57fb5wy6cm30r2cjv2vffrdi142wjxzvrqdr08lmi5nf57gi1sng"; }
  ];
}
