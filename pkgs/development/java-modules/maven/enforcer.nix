{ fetchMaven }:

rec {
  mavenEnforcerApi_1_3_1 = map (obj: fetchMaven {
    version = "1.3.1";
    artifactId = "enforcer-api";
    groupId = "org.apache.maven.enforcer";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2bh75j9f1hf80yhikd2r014kq8pgf9b49w62w7v9772kwdsza84v527vph0ifldpk561aivz5v604a9rpw5zb03gkixr51qspmsg2hp"; }
    { type = "jar"; sha512 = "2pi1df9brkrlqp36pvk8ccc308b2882nmb2c1pbp2vaf4v95wm529vyng5gv9012l6c293ciamaxiv019zv04hl3zsgpk0m5fg3qhs0"; }
  ];

  mavenEnforcerRules_1_3_1 = map (obj: fetchMaven {
    version = "1.3.1";
    artifactId = "enforcer-rules";
    groupId = "org.apache.maven.enforcer";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "16i11v6rlym87zvq3x0nn7m8g5w3vyf3g097cz79a3hjmzf3zk12837wi007697nr5dfd3sq9r9cgxmqw77y6cyphaic71hmhv4jx7c"; }
    { type = "jar"; sha512 = "33xp9dgdml15bf8dpw4b61wfqnkypixd697q60lan3hvv10bs33jfw8xxsj2pl2l11hca6whk2c1wdddc913s88r13zzaghgizwsx55"; }
  ];
}
