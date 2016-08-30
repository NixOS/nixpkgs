{ fetchmaven, fetchurl }:

rec {
  mavenPlugin243Jar = fetchmaven {
    version = "2.4.3";
    name = "bootstrap-maven-plugin-plugin-jar-2.4.3";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/2.4.3/maven-plugin-plugin-2.4.3.jar";
      sha256 = "052mb7kaljyqhzr06m5q3zx2gj37rsv18hyp6bwmfc67dc02wan6";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.4.3";
    m2File = "maven-plugin-plugin-2.4.3.jar";
  };

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

  mavenPlugin27Jar = fetchmaven {
    version = "2.7";
    name = "bootstrap-maven-plugin-plugin-jar-2.7";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/2.7/maven-plugin-plugin-2.7.jar";
      sha256 = "155cphfjyy82rwya30pb34klsq49gr91aakvivl0f9cg1rs25qvc";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.7";
    m2File = "maven-plugin-plugin-2.7.jar";
  };

  mavenPlugin28Jar = fetchmaven {
    version = "2.8";
    name = "bootstrap-maven-plugin-plugin-jar-2.8";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/2.8/maven-plugin-plugin-2.8.jar";
      sha256 = "03kp6qknsls7iy5p56aa33l8sih66mjx3cwjalmw94j515nrnim9";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.8";
    m2File = "maven-plugin-plugin-2.8.jar";
  };

  mavenPlugin31Jar = fetchmaven {
    version = "3.1";
    name = "bootstrap-maven-plugin-plugin-jar-3.1";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/3.1/maven-plugin-plugin-3.1.jar";
      sha256 = "131dyxh8f5l5ygflf6j1yr3wnzzjnkvlhil04a4k77ld5k0dycv6";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/3.1";
    m2File = "maven-plugin-plugin-3.1.jar";
  };

  mavenPlugin32Jar = fetchmaven {
    version = "3.2";
    name = "bootstrap-maven-plugin-plugin-jar-3.2";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/plugins/maven-plugin-plugin/3.2/maven-plugin-plugin-3.2.jar";
      sha256 = "1jy9ghdk36qqnz413jc7glyp8kps4f7h69mpr2h073zb2qcpayl8";
    };
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/3.2";
    m2File = "maven-plugin-plugin-3.2.jar";
  };
}
