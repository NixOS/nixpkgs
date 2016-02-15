{ fetchmaven, fetchurl }:

rec {
  mavenCompiler31Jar = fetchmaven {
    version = "3.1";
    name = "bootstrap-maven-compiler-plugin-jar-3.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.1/maven-compiler-plugin-3.1.jar";
      sha256 = "1ih2qg9xa5zjwrmwkyqlx2vi2mncqihmlhaj3kih9yjbibc6qa32";
    };
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/3.1";
    m2File = "maven-compiler-plugin-3.1.jar";
  };
}
