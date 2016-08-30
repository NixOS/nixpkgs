{ fetchmaven, fetchurl }:

rec {
  mavenSite31Jar = fetchmaven {
    version = "3.1";
    name = "bootstrap-maven-site-plugin-jar-3.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-site-plugin/3.1/maven-site-plugin-3.1.jar";
      sha256 = "0dn3fq8r05nkmymb7fc0kahh0fkhpjhr91ccr1sc4bqz3g63878x";
    };
    m2Path = "/org/apache/maven/plugins/maven-site-plugin/3.1";
    m2File = "maven-site-plugin-3.1.jar";
  };
}
