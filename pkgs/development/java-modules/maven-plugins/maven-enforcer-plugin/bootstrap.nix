{ fetchmaven, fetchurl }:

rec {
  mavenEnforcer10Jar = fetchmaven {
    version = "1.0";
    name = "bootstrap-maven-enforcer-plugin-jar-1.0";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-enforcer-plugin/1.0/maven-enforcer-plugin-1.0.jar";
      sha256 = "0q5ys22z5s6k9fnvwhjas8g7y8szrxz3ap9fkswv9pslq7nrrwsn";
    };
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0";
    m2File = "maven-enforcer-plugin-1.0.jar";
  };

  mavenEnforcer10Pom = fetchmaven {
    version = "1.0";
    name = "bootstrap-maven-enforcer-plugin-pom-1.0";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-enforcer-plugin/1.0/maven-enforcer-plugin-1.0.pom";
      sha256 = "0i84r6cyskr6p5spk1fgkx2dm9fm4ss6ykgkzl4ly89kcrwdfzgg";
    };
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0";
    m2File = "maven-enforcer-plugin-1.0.pom";
  };
}
