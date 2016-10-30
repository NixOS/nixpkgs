{ fetchMaven }:

rec {
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
}
