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

  apacheParent5 = fetchmaven {
    version = 5;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/5/apache-5.pom";
      sha256 = "12dfsn6i149b0p941lppi26zv01q270czb7ylayqkcrrfh1sccqr";
    };
    m2Path = "org/apache/apache/5";
    m2File = "apache-5.pom";
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

  apacheParent8 = fetchmaven {
    version = 8;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/8/apache-8.pom";
      sha256 = "07id266pgmvd092y3zkvmxx1nd3lz58347zh366mvwd6grj0alcy";
    };
    m2Path = "org/apache/apache/8";
    m2File = "apache-8.pom";
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

  apacheParent11 = fetchmaven {
    version = 11;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/11/apache-11.pom";
      sha256 = "0yr9142xp9myaa361ma349bcrnb4hz2f7sa1cimi3n21vfnvakws";
    };
    m2Path = "org/apache/apache/11";
    m2File = "apache-11.pom";
  };

  apacheParent13 = fetchmaven {
    version = 13;
    name = "apache-parent";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/apache/13/apache-13.pom";
      sha256 = "07c4yg52q1qiz2b982pcsiwf9ahmpil4jy7lpqvi5m0z6sq3slgz";
    };
    m2Path = "org/apache/apache/13";
    m2File = "apache-13.pom";
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
      sha256 = "0l5xcmkk0h3r47lpdny9a9zd5w0v48pk702kqhimh5bkj4i2lz2x";
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

  mavenParent8 = fetchmaven {
    version = 8;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-8/pom.xml";
      sha256 = "0z3kyqsscrfqzs46iaxcnla52gx4dx85bhpnajlq2mrw7c7ldagi";
    };
    m2Path = "org/apache/maven/maven-parent/8";
    m2File = "maven-parent-8.pom";
  };

  mavenParent9 = fetchmaven {
    version = 9;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-9/pom.xml";
      sha256 = "16f68dry12lwzqdjkan7zw7wyyqsj0isxb41sjnabv2si4sa7pa7";
    };
    m2Path = "org/apache/maven/maven-parent/9";
    m2File = "maven-parent-9.pom";
  };

  mavenParent11 = fetchmaven {
    version = 11;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-11/pom.xml";
      sha256 = "1dyxv5jsrw71s18gi77jf7laf03l2ww0j29shmlp9cayhvw7vmsh";
    };
    m2Path = "org/apache/maven/maven-parent/11";
    m2File = "maven-parent-11.pom";
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

  mavenParent15 = fetchmaven {
    version = 15;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-15/pom.xml";
      sha256 = "13kjd2xzfghf6kjsj755gdfy10x6vsj9gdn6gy0y3px2ga2nkjgn";
    };
    m2Path = "org/apache/maven/maven-parent/15";
    m2File = "maven-parent-15.pom";
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

  mavenParent18 = fetchmaven {
    version = 18;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-18/pom.xml";
      sha256 = "1fylyndpdhzgawrx1zhigl17kxywvnqa6sw6g9ay6sw9hjj1fl84";
    };
    m2Path = "org/apache/maven/maven-parent/18";
    m2File = "maven-parent-18.pom";
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

  mavenParent22 = fetchmaven {
    version = 22;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-22/pom.xml";
      sha256 = "16mpmp92r6398rgs75lfpcf3dhsv6bjgxz8qxfs9h1h732bl0nhn";
    };
    m2Path = "org/apache/maven/maven-parent/22";
    m2File = "maven-parent-22.pom";
  };

  mavenParent23 = fetchmaven {
    version = 23;
    name = "maven-parent";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/pom/tags/maven-parent-23/pom.xml";
      sha256 = "118nah9ig7kmqvwh84qma54d4dk8w29cqlya3sqdf2wyvlg509al";
    };
    m2Path = "org/apache/maven/maven-parent/23";
    m2File = "maven-parent-23.pom";
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

  mavenPlugins11 = fetchmaven {
    version = 11;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-11/pom.xml";
      sha256 = "0rmvx46sil9jzn65rlhdp8yv8vvjbcs9iw8aj7f3qlxyiqj48pqh";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/11";
    m2File = "maven-plugins-11.pom";
  };

  mavenPlugins12 = fetchmaven {
    version = 12;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-12/pom.xml";
      sha256 = "0gigvxlamvzwwwii4s0b4zml3cb85nkrmv1v0nicgqmcx1kngbzg";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/12";
    m2File = "maven-plugins-12.pom";
  };

  mavenPlugins13 = fetchmaven {
    version = 13;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-13/pom.xml";
      sha256 = "1ywhhds68nq52p6kfxq1a3py80dj8f0qyx4nh835v1197a9ccy6n";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/13";
    m2File = "maven-plugins-13.pom";
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

  mavenPlugins16 = fetchmaven {
    version = 16;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-16/pom.xml";
      sha256 = "1ly8zjk2y1zh5ykgvvdivnnlf9hpx5nc3xl7mwjxcgycq90rckjz";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/16";
    m2File = "maven-plugins-16.pom";
  };

  mavenPlugins17 = fetchmaven {
    version = 17;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-17/pom.xml";
      sha256 = "06kf5k3j3ygvsp6bl6vxg3i8bai6inaplvinapv11dhi2i5fybl7";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/17";
    m2File = "maven-plugins-17.pom";
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

  mavenPlugins20 = fetchmaven {
    version = 20;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-20/pom.xml";
      sha256 = "1kgzlhhhqc04hp9gh8riy28zk0yhqvfkf9gj96yx94l9611ss6bp";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/20";
    m2File = "maven-plugins-20.pom";
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

  mavenPlugins23 = fetchmaven {
    version = 23;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-23/pom.xml";
      sha256 = "1kir8ray9ndiawf4sdls1i38z9x1v105is5gzk477a0nsp3i0xz0";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/23";
    m2File = "maven-plugins-23.pom";
  };

  mavenPlugins24 = fetchmaven {
    version = 24;
    name = "maven-plugins";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-plugins-24/pom.xml";
      sha256 = "0mly2jydjqf455mic36hcjz2cx6682icw5wfz3v9ia6ifaykifmz";
    };
    m2Path = "org/apache/maven/plugins/maven-plugins/24";
    m2File = "maven-plugins-24.pom";
  };

  mavenPluginTools31 = fetchmaven {
    version = "3.1";
    name = "maven-plugin-tools";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-3.1/pom.xml";
      sha256 = "1v5bcspzanm5km7gh1b9i5dz0ycgrxmkggk2kmwiahcigi0j4d7a";
    };
    m2Path = "org/apache/maven/plugin-tools/maven-plugin-tools/3.1";
    m2File = "maven-plugin-tools-3.1.pom";
  };

  mavenPluginTools32 = fetchmaven {
    version = "3.2";
    name = "maven-plugin-tools";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-3.2/pom.xml";
      sha256 = "07wjr4irs3mq9qzs6z0jbww2f4abn0y6b30lqbzj41chmjlzkxrn";
    };
    m2Path = "org/apache/maven/plugin-tools/maven-plugin-tools/3.2";
    m2File = "maven-plugin-tools-3.2.pom";
  };

  mavenShared15 = fetchmaven {
    version = "15";
    name = "maven-shared-components";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/shared/tags/maven-shared-components-15/pom.xml";
      sha256 = "1n2lfks6h5iaqyhf2av5mfdq7sylbwg87a12ivlnlql8icg5b0ar";
    };
    m2Path = "org/apache/maven/shared/maven-shared-components/15";
    m2File = "maven-shared-components-15.pom";
  };


  plexusParent205 = fetchmaven {
    version = "2.0.5";
    name = "plexus-pom-2.0.5";
    src = fetchurl rec {
      url = "https://raw.githubusercontent.com/sonatype/plexus-pom/plexus-2.0.5/pom.xml";
      sha256 = "0882f9y732q5nb7c39ysv6rs744hcmqz2s66nqcyn3ckxdn8y655";
    };
    m2Path = "org/codehaus/plexus/plexus/2.0.5";
    m2File = "plexus-2.0.5.pom";
  };

  surefireParent23 = fetchmaven {
    version = "2.3";
    name = "surefire-pom-2.3";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.3/pom.xml";
      sha256 = "1v9l261fa6bvwippnh4v3780zjiy254hj56j7za1hcsl4cf53pfb";
    };
    m2Path = "org/apache/maven/surefire/surefire/2.3";
    m2File = "surefire-2.3.pom";
  };

  surefireParent231 = fetchmaven {
    version = "2.3.1";
    name = "surefire-pom-2.3.1";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.3.1/pom.xml";
      sha256 = "1bkm8j884gng2n8f61xj2yhqgj2m7pxxdd3aw96v2j4iyqh6i0n8";
    };
    m2Path = "org/apache/maven/surefire/surefire/2.3.1";
    m2File = "surefire-2.3.1.pom";
  };

  surefireParent243 = fetchmaven {
    version = "2.4.3";
    name = "surefire-pom-2.4.3";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.4.3/pom.xml";
      sha256 = "1app47rsdqa44q6c7c20ddmjzirg76i4phz21d6d1cj0xfqlar76";
    };
    m2Path = "org/apache/maven/surefire/surefire/2.4.3";
    m2File = "surefire-2.4.3.pom";
  };

  surefireParent272 = fetchmaven {
    version = "2.7.2";
    name = "surefire-pom-2.7.2";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.7.2/pom.xml";
      sha256 = "1wsr23f38viz14md090k0f6p6rq7mkn89d9yssngi25zf90j7dlf";
    };
    m2Path = "org/apache/maven/surefire/surefire/2.7.2";
    m2File = "surefire-2.7.2.pom";
  };

  surefireParent28 = fetchmaven {
    version = "2.8";
    name = "surefire-pom-2.8";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.8/pom.xml";
      sha256 = "00zvjjlbrwb43710dkp4km9j2vsf153w9q80dy5ra06x6fq0yd1w";
    };
    m2Path = "org/apache/maven/surefire/surefire/2.8";
    m2File = "surefire-2.8.pom";
  };

  surefireParent29 = fetchmaven {
    version = "2.9";
    name = "surefire-pom-2.9";
    src = fetchurl rec {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.9/pom.xml";
      sha256 = "1pz20f5lfwnamgbr51hdy7gj0zpk0gs8c4zgidkkwpi39qssjkxy";
    };
    m2Path = "org/apache/maven/surefire/surefire/2.9";
    m2File = "surefire-2.9.pom";
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
