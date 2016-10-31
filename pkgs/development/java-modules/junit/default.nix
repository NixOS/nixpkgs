{ stdenv, pkgs, mavenbuild, fetchMaven }:

with pkgs.javaPackages;

rec {
  junitGen = { mavenDeps, sha512, version }: mavenbuild rec {
    inherit mavenDeps sha512 version;

    name = "junit-${version}";
    src = pkgs.fetchFromGitHub {
      inherit sha512;
      owner = "junit-team";
      repo = "junit4";
      rev = "r${version}";
    };
    m2Path = "/junit/junit/${version}";

    meta = {
      homepage = http://junit.org/junit4/;
      description = "Simple framework to write repeatable tests. It is an instance of the xUnit architecture for unit testing frameworks";
      license = stdenv.lib.licenses.epl10;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  junit_3_8_1 = map (obj: fetchMaven {
    version = "3.8.1";
    baseName = "junit";
    package = "/junit";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2b368057s8i61il387fqvznn70r9ndm815r681fn9i5afs1qgkw7i1d6vsn3pv2bbif1kmhb7qzcc574m3xcwc8a2mqw44b4bbxsfyl"; }
    { type = "jar"; sha512 = "25yk0lzwk46r867nhrw4hg7cvz28wb8ln9nw1dqrb6zarifl54p4h1mcz90vmih405bsk96g0qb6hn1h4df0fas3f5kma9vxfjryvwf"; }
  ];

  junit_3_8_2 = map (obj: fetchMaven {
    version = "3.8.2";
    baseName = "junit";
    package = "/junit";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "01npyfwl1f44l44x92cvqqcp58sckcjraf78dav6zgag3x6ispd9gz594nhpqckmjw0hlrkbqfxnzdcq1mlsj9rw6zyq4wk5ch8rl5j"; }
    { type = "jar"; sha512 = "2jcih102666lcm7b23rgs5cd59ww49m78c8mja52mrcm25630zw28rjqkj5lsws18k5jf75div9wkd1sxcvwvq5cvvphgyg7550i8r9"; }
  ];

  junit_4_12 = junitGen {
    mavenDeps = [ mavenPlugins.animalSniffer_1_11 hamcrestCore_1_3 plexusUtils_1_1 ];
    sha512 = "0bbldnf37jl855s1pdx2a518ivfifv75189vsbpylnj8530vnf8z6b2dglkcbcjgr22lp1s4m1nnplz5dmka9sr7vj055p88k27kqw9";
    version = "4.12";
  };
}
