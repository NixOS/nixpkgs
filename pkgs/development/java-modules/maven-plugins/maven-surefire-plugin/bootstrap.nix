{ fetchmaven, fetchurl }:

rec {
  mavenSurefire23Jar = fetchmaven {
    version = "2.3";
    name = "bootstrap-maven-surefire-plugin-jar-2.3";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-surefire-plugin/2.3/maven-surefire-plugin-2.3.jar";
      sha256 = "1afn5yyv61myl48dqgpzxw142475y9vahz3gs8ikcsdh5v3vln9l";
    };
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.3";
    m2File = "maven-surefire-plugin-2.3.jar";
  };

  mavenSurefire272Jar = fetchmaven {
    version = "2.7.2";
    name = "bootstrap-maven-surefire-plugin-jar-2.7.2";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-surefire-plugin/2.7.2/maven-surefire-plugin-2.7.2.jar";
      sha256 = "0kp8a56mfzk7qwc48y1fp3fxgh1rwgz623hs4617f9v53dnbgx24";
    };
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.7.2";
    m2File = "maven-surefire-plugin-2.7.2.jar";
  };
}
