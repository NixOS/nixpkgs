{ fetchmaven, fetchurl }:

rec {
  mavenJar231Jar = fetchmaven {
    version = "2.3.1";
    name = "bootstrap-maven-jar-plugin-jar-2.3.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-jar-plugin/2.3.1/maven-jar-plugin-2.3.1.jar";
      sha256 = "1484gqpkdkk61h1mcs1kypf9fdsic8nq6c38gqgy1l4q7r977ijj";
    };
    m2Path = "/org/apache/maven/plugins/maven-jar-plugin/2.3.1";
    m2File = "maven-jar-plugin-2.3.1.jar";
  };
}
