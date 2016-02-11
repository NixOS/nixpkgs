{ fetchmaven, fetchurl }:

rec {
  mavenResources26Jar = fetchmaven {
    version = "2.6";
    name = "bootstrap-maven-resources-plugin-jar-2.6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-resources-plugin/2.6/maven-resources-plugin-2.6.jar";
      sha256 = "19lci1jq5jfcw0p8rwlkp44xrfb36jdrmydwza8syadhnnc1pg87";
    };
    m2Path = "/org/apache/maven/plugins/maven-resources-plugin/2.6";
    m2File = "maven-resources-plugin-2.6.jar";
  };
}
