{ fetchmaven, fetchurl }:

rec {
  mavenClean241Jar = fetchmaven {
    version = "2.4.1";
    name = "bootstrap-maven-clean-plugin-jar-2.4.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.4.1/maven-clean-plugin-2.4.1.jar";
      sha256 = "1jl96cwydk8dcfvyabbywygg5lqza3vgnndqh60drd4kngvax615";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4.1";
    m2File = "maven-clean-plugin-2.4.1.jar";
  };

  mavenClean241Pom = fetchmaven {
    version = "2.4.1";
    name = "bootstrap-maven-clean-plugin-pom-2.4.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-clean-plugin/2.4.1/maven-clean-plugin-2.4.1.pom";
      sha256 = "0swwg1yd7zxv904l5b7v2qbyd862q4amlxmxxk59z3caw3cxjhd0";
    };
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4.1";
    m2File = "maven-clean-plugin-2.4.1.pom";
  };
}
