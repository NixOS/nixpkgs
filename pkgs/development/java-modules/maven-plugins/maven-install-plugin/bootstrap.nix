{ fetchmaven, fetchurl }:

rec {
  mavenInstall231Jar = fetchmaven {
    version = "2.3.1";
    name = "bootstrap-maven-install-plugin-jar-2.3.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-install-plugin/2.3.1/maven-install-plugin-2.3.1.jar";
      sha256 = "0q7zh6ncmh7s8f34b82nlxpsv7z2nag009nks825b7i1x584a5c2";
    };
    m2Path = "/org/apache/maven/plugins/maven-install-plugin/2.3.1";
    m2File = "maven-install-plugin-2.3.1.jar";
  };
}
