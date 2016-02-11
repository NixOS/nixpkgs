{ fetchmaven, fetchurl }:

rec {
  mavenEnforcer10alpha4Jar = fetchmaven {
    version = "1.0-alpha-4";
    name = "bootstrap-maven-enforcer-plugin-jar-1.0-alpha-4";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-enforcer-plugin/1.0-alpha-4/maven-enforcer-plugin-1.0-alpha-4.jar";
      sha256 = "1b51r58z5725c9azbb8xz7rfjldzivc66b59x3rs31bf2l4zqg7c";
    };
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0-alpha-4";
    m2File = "maven-enforcer-plugin-1.0-alpha-4.jar";
  };

  mavenEnforcer10beta1Jar = fetchmaven {
    version = "1.0-beta-1";
    name = "bootstrap-maven-enforcer-plugin-jar-1.0-beta-1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-enforcer-plugin/1.0-beta-1/maven-enforcer-plugin-1.0-beta-1.jar";
      sha256 = "0gzas0idr84xbfd9mgwvj689nrnwpqm30p4vih7b2fpwqyq3pknd";
    };
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0-beta-1";
    m2File = "maven-enforcer-plugin-1.0-beta-1.jar";
  };

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

  mavenEnforcer101Jar = fetchmaven {
    version = "1.0.1";
    name = "bootstrap-maven-enforcer-plugin-jar-1.0.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-enforcer-plugin/1.0.1/maven-enforcer-plugin-1.0.1.jar";
      sha256 = "11cjlz0clnimrlyhrg6a21vw4hwjq3biplffmj3m3y7mwy5yvbyf";
    };
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0.1";
    m2File = "maven-enforcer-plugin-1.0.1.jar";
  };
}
