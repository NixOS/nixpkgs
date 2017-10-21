{ fetchMaven }:

rec {
  mavenArtifactManager_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-artifact-manager";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0xciyvsl2l6fnd5k5dbhz5iih66fgacdagcrflk6cfiiv3qng5zrhx61v9fbjr0fpxbj7rswkczv7vn46359nlkb80513jwhzs8gqwv"; }
    { type = "pom"; sha512 = "1j20ygljm0qa10ryw72j9q4jlwnsjdrcdg08a10ar456zi8gxzszp5cd0xsp0j29q69bp3wck2ggfr028v0zxivxgvakm4fa6l33sya"; }
  ];

  mavenArtifactManager_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-artifact-manager";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1alp2iahaaf39yd3xp8817sz93nhz53flkkv5dx87vybsizpykb1g7jn6bnx0cbqqr9k5pi27z8mbkmry05vwqc6jyic1pyvzy1y3vn"; }
    { type = "pom"; sha512 = "3pvj8gpcg57akalj4574k4mzw2skgm0w69bdvh0ivyd8skgdrf5gwxf57hl5rbgsdpr82m2za7yvi63fw82k7v84sib904fs639r3pf"; }
  ];

  mavenArtifactManager_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-artifact-manager";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1vvxf2dannx9p2qvlbmrxfni5mc0f3722p3bcdz6bk3z4dhb2hlw2wx17nvirq5r3k43azgp13mg0638saz7v1g23f07n9yzm979f0p"; }
    { type = "pom"; sha512 = "2v7371gsarjb4s2bp5vclqgdg82mh7nzy7af31g9z20q2r6ndw024xa8bpcxp227yv83lpawbhq0ysg0glnw9ql54100h9hbllam0p8"; }
  ];

  mavenArtifactManager_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-artifact-manager";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "04i9c4k5diyqz8hn20sxvrqkqrxxm7wxqh7xgyk3dm1hwhrqy3h29irvpb335kp8i0sxljz2p2a9cmjpx9wyl0266bj5y313whmfkr5"; }
    { type = "pom"; sha512 = "02ryc46in725q4y11l1kmy6ra01wjnfq5gqwic005wc090l2j39kn5drvn3av6g7413v9x0cksy8qcbagc2jnz6wwxn8z2g5krynw6z"; }
  ];
}
