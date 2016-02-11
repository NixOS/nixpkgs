{ fetchmaven, fetchurl }:

rec {
  mavenPlugin251Jar = fetchmaven {
    version = "2.5.1";
    name = "bootstrap-maven-plugin-plugin-jar-2.5.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/2.5.1/maven-plugin-plugin-2.5.1.jar";
      sha256 = "1af5r4da4fz3rdplqhbqh1s9z6k7bwlvpprfvva41122dlg6ylfm";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.5.1";
    m2File = "maven-plugin-plugin-2.5.1.jar";
  };

  mavenPlugin26Jar = fetchmaven {
    version = "2.6";
    name = "bootstrap-maven-plugin-plugin-jar-2.6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/2.6/maven-plugin-plugin-2.6.jar";
      sha256 = "14ffbjm78f9l0sbxm854922jv987fcwd3lblcg6vcg8kqqsqqbi2";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.6";
    m2File = "maven-plugin-plugin-2.6.jar";
  };
}
