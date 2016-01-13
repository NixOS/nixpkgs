{ fetchmaven, fetchurl }:


rec {
  apacheCommonsParent24 = fetchmaven {
    version = 24;
    name = "commons-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/commons/proper/commons-parent/tags/commons-parent-24/pom.xml";
      sha256 = "1x47bsd0sbgj7310k3prqix6qa0zk49rvg20sy0hlvvcf4hj9mnx";
    };
    m2Path = "org/apache/commons/commons-parent/24";
    m2File = "commons-parent-24.pom";
  };

  apacheParent4 = fetchmaven {
    version = 4;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/4/apache-4.pom";
      sha256 = "152iri0kbrxir93w23b31045gpvh3g9rc37gxya27sx8dfi274wy";
    };
    m2Path = "org/apache/apache/4";
    m2File = "apache-4.pom";
  };

  apacheParent6 = fetchmaven {
    version = 6;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/6/apache-6.pom";
      sha256 = "1csvz8bb2l6fk5ks4gqj0mjmiaczb010km0b5lv0rx0kdq4vbv8j";
    };
    m2Path = "org/apache/apache/6";
    m2File = "apache-6.pom";
  };

  apacheParent9 = fetchmaven {
    version = 9;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/9/apache-9.pom";
      sha256 = "1p8qrz7swd6ylwfiv6x4kr3gip6sy2vca8xwydlxm3kwah5fcij9";
    };
    m2Path = "org/apache/apache/9";
    m2File = "apache-9.pom";
  };

  mavenParent5 = fetchmaven {
    version = 5;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-5/pom.xml";
      sha256 = "10wj48s4n0ir61apmsq1s94sixh3azknpky5nh6vwihs5v32srld";
    };
    m2Path = "org/apache/maven/maven-parent/5";
    m2File = "maven-parent-5.pom";
  };

  mavenParent7 = fetchmaven {
    version = 7;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-7/pom.xml";
      sha256 = "10wj48s4n0ir61apmsq1s94sixh3azknpky5nh6vwihs5v32srld";
    };
    m2Path = "org/apache/maven/maven-parent/7";
    m2File = "maven-parent-7.pom";
  };

  mavenParent13 = fetchmaven {
    version = 13;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-13/pom.xml";
      sha256 = "1nmavqw81ayv1bcyvkhckc3a46n678b1p039pf1iwvrch6n2pl3j";
    };
    m2Path = "org/apache/maven/maven-parent/13";
    m2File = "maven-parent-13.pom";
  };

  mavenParent19 = fetchmaven {
    version = 19;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-19/pom.xml";
      sha256 = "0v40bkhd3d0fbg5hpnc83fgj55999zgdnl2b8rjjc4ihc0gqzdlz";
    };
    m2Path = "org/apache/maven/maven-parent/19";
    m2File = "maven-parent-19.pom";
  };

  mavenPlugins8 = fetchmaven {
    version = 8;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-8/maven-plugins-8.pom";
      sha256 = "1lrwyib23yqx4qxq5hh73mx48v31r41sfvvyxr4gqw4hfcjrs68d";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/8";
    m2File = "maven-plugins-8.pom";
  };

  mavenPlugins10 = fetchmaven {
    version = 10;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-10/pom.xml";
      sha256 = "1c8910564w0wvyjrbqf95zygifqpx1dxx2gl44642wpb2hyj3p10";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/10";
    m2File = "maven-plugins-10.pom";
  };

  mavenPlugins14 = fetchmaven {
    version = 14;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-14/pom.xml";
      sha256 = "1p3w14rm6fpw5cnapdm7p8x3l5wk6xblqx5jib4pbdx2nd0h4bn5";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/14";
    m2File = "maven-plugins-14.pom";
  };

  mavenPlugins19 = fetchmaven {
    version = 19;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-19/pom.xml";
      sha256 = "1jk2wlwnbhw1s6rqgx23r8zk9mqspfvcq4dr0fkrq2hyi1kcn0ic";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/19";
    m2File = "maven-plugins-19.pom";
  };
}
