{ fetchmaven, fetchurl }:

rec {
  modelloMaven10alpha15Jar = fetchmaven {
    version = "1.0-alpha-15";
    name = "bootstrap-modello-maven-plugin-jar-1.0-alpha-15";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/codehaus/modello/modello-maven-plugin/1.0-alpha-15/modello-maven-plugin-1.0-alpha-15.jar";
      sha256 = "0f6xw8anpnsvdkdcl4yqs5fhiwvbqyyyri3f14cyyd4yg5b0d8i4";
    };
    m2Path = "/org/codehaus/modello/modello-maven-plugin/1.0-alpha-15";
    m2File = "modello-maven-plugin-1.0-alpha-15.jar";
  };

  modelloMaven141Jar = fetchmaven {
    version = "1.4.1";
    name = "bootstrap-modello-maven-plugin-jar-1.4.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/codehaus/modello/modello-maven-plugin/1.4.1/modello-maven-plugin-1.4.1.jar";
      sha256 = "1n25qfk99v5cnfy0fwbq27znakcibiy3zwykp200v0ci4c72wx8m";
    };
    m2Path = "/org/codehaus/modello/modello-maven-plugin/1.4.1";
    m2File = "modello-maven-plugin-1.4.1.jar";
  };
}
