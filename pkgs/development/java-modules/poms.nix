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

  apacheParent3 = fetchmaven {
    version = 3;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/3/apache-3.pom";
      sha256 = "03m2hw8lmc4d600wwbmmfngv240639daaxskgssnxampnjpm0g1r";
    };
    m2Path = "org/apache/apache/3";
    m2File = "apache-3.pom";
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

  apacheParent7 = fetchmaven {
    version = 7;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/7/apache-7.pom";
      sha256 = "09bc9gxpi3pnb2gf4jhzfm418s1ks6b79w6v4grckb9knhfwx5qk";
    };
    m2Path = "org/apache/apache/7";
    m2File = "apache-7.pom";
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

  apacheParent10 = fetchmaven {
    version = 10;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/10/apache-10.pom";
      sha256 = "1yfsi68mca0i91cswnpanswmqb67cw1sc9d4s35sybc5fb7fwbw0";
    };
    m2Path = "org/apache/apache/10";
    m2File = "apache-10.pom";
  };

  mavenEnforcerParent10Pom = fetchmaven {
    version = "1.0";
    name = "maven-enforcer";
    src = fetchurl rec {
      url = "https://svn.apache.org/repos/asf/maven/enforcer/tags/enforcer-1.0/pom.xml";
      sha256 = "033w1wlj1d16r6vylcsvqch74iw4lz6iqlvmh0hm6j3cqn2cbfli";
    };
    m2Path = "org/apache/maven/enforcer/enforcer/1.0";
    m2File = "enforcer-1.0.pom";
  };

  mavenParent4 = fetchmaven {
    version = 4;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-5/pom.xml";
      sha256 = "0l5xcmkk0h3r47lpdny9a9zd5w0v48pk702kqhimh5bkj4i2lz2x";
    };
    m2Path = "org/apache/maven/maven-parent/4";
    m2File = "maven-parent-4.pom";
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

  mavenParent16 = fetchmaven {
    version = 16;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-16/pom.xml";
      sha256 = "0v40bkhd3d0fbg5hpnc83fgj55999zgdnl2b8rjjc4ihc0gqzdlz";
    };
    m2Path = "org/apache/maven/maven-parent/16";
    m2File = "maven-parent-16.pom";
  };

  mavenParent17 = fetchmaven {
    version = 17;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-17/pom.xml";
      sha256 = "0bzcr59hqqiaivz1pi7vjkfaan5qlc6k2rkhvwi4q28dasajacln";
    };
    m2Path = "org/apache/maven/maven-parent/17";
    m2File = "maven-parent-17.pom";
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

  mavenParent21 = fetchmaven {
    version = 21;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-21/pom.xml";
      sha256 = "13nvx45d1maqxgkijmhsq7lh365ng0gyykjnawdpsc7a264syigw";
    };
    m2Path = "org/apache/maven/maven-parent/21";
    m2File = "maven-parent-21.pom";
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

  mavenPlugins18 = fetchmaven {
    version = 18;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-18/pom.xml";
      sha256 = "0ag1xvl93irhmpnih10096pn1iqx1y7mc613ywdd6ci6magn1kc4";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/18";
    m2File = "maven-plugins-18.pom";
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

  mavenPlugins22 = fetchmaven {
    version = 22;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-22/pom.xml";
      sha256 = "0c0njhgda8njvb7qygdminqsywjb2c79nm3h2md4zlrivnxh7lrl";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/22";
    m2File = "maven-plugins-22.pom";
  };

  wagon10beta2 = fetchmaven {
    version = "1.0-beta2";
    name = "wagon";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/wagon/tags/wagon-1.0-beta-2/pom.xml";
      sha256 = "1yssnc8w2xyak11qnm5xbwl79haxmcspm1l8k1a49v20bg4jrnpc";
    };
    m2Path = "org/apache/maven/wagon/wagon/1.0-beta-2";
    m2File = "wagon-1.0-beta-2.pom";
  };

  wagonProviders10beta2 = fetchmaven {
    version = "1.0-beta2";
    name = "wagon-providers";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/wagon/tags/wagon-1.0-beta-2/wagon-providers/pom.xml";
      sha256 = "1q4lj4w9xp2g9z8745836n69d5w74y8qk47vb6c59hzm159fbqmj";
    };
    m2Path = "org/apache/maven/wagon/wagon-providers/1.0-beta-2";
    m2File = "wagon-providers-1.0-beta-2.pom";
  };
}
