{ fetchMaven }:

rec {
  mavenArtifactManager_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-artifact-manager";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1alp2iahaaf39yd3xp8817sz93nhz53flkkv5dx87vybsizpykb1g7jn6bnx0cbqqr9k5pi27z8mbkmry05vwqc6jyic1pyvzy1y3vn"; }
    { type = "pom"; sha512 = "3pvj8gpcg57akalj4574k4mzw2skgm0w69bdvh0ivyd8skgdrf5gwxf57hl5rbgsdpr82m2za7yvi63fw82k7v84sib904fs639r3pf"; }
  ];

  mavenArtifactManager_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-artifact-manager";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1vvxf2dannx9p2qvlbmrxfni5mc0f3722p3bcdz6bk3z4dhb2hlw2wx17nvirq5r3k43azgp13mg0638saz7v1g23f07n9yzm979f0p"; }
    { type = "pom"; sha512 = "2v7371gsarjb4s2bp5vclqgdg82mh7nzy7af31g9z20q2r6ndw024xa8bpcxp227yv83lpawbhq0ysg0glnw9ql54100h9hbllam0p8"; }
  ];

  mavenArtifactManager_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-artifact-manager";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1vvxf2dannx9p2qvlbmrxfni5mc0f3722p3bcdz6bk3z4dhb2hlw2wx17nvirq5r3k43azgp13mg0638saz7v1g23f07n9yzm979f0p"; }
    { type = "pom"; sha512 = "2v7371gsarjb4s2bp5vclqgdg82mh7nzy7af31g9z20q2r6ndw024xa8bpcxp227yv83lpawbhq0ysg0glnw9ql54100h9hbllam0p8"; }
  ];
}
