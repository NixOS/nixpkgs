{ stdenv, pkgs, mavenbuild, fetchMaven }:

with pkgs.javaPackages;

let
  poms = import (../poms.nix) { inherit fetchMaven; };
  collections = import (../collections.nix) { inherit pkgs; };
in rec {
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
      homepage = https://junit.org/junit4/;
      description = "Simple framework to write repeatable tests. It is an instance of the xUnit architecture for unit testing frameworks";
      license = stdenv.lib.licenses.epl10;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  junit_3_8_1 = map (obj: fetchMaven {
    version = "3.8.1";
    artifactId = "junit";
    groupId = "junit";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2b368057s8i61il387fqvznn70r9ndm815r681fn9i5afs1qgkw7i1d6vsn3pv2bbif1kmhb7qzcc574m3xcwc8a2mqw44b4bbxsfyl"; }
    { type = "jar"; sha512 = "25yk0lzwk46r867nhrw4hg7cvz28wb8ln9nw1dqrb6zarifl54p4h1mcz90vmih405bsk96g0qb6hn1h4df0fas3f5kma9vxfjryvwf"; }
  ];

  junit_3_8_2 = map (obj: fetchMaven {
    version = "3.8.2";
    artifactId = "junit";
    groupId = "junit";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "01npyfwl1f44l44x92cvqqcp58sckcjraf78dav6zgag3x6ispd9gz594nhpqckmjw0hlrkbqfxnzdcq1mlsj9rw6zyq4wk5ch8rl5j"; }
    { type = "jar"; sha512 = "2jcih102666lcm7b23rgs5cd59ww49m78c8mja52mrcm25630zw28rjqkj5lsws18k5jf75div9wkd1sxcvwvq5cvvphgyg7550i8r9"; }
  ];

  junit_4_12 = junitGen {
    mavenDeps = (with mavenPlugins; [ animalSniffer_1_11 mavenEnforcer_1_3_1 mavenReplacer_1_5_3 mavenSurefire_2_17 ])
                  ++ collections.mavenLibs_2_0_1
                  ++ [ aetherUtil_0_9_0_M2 ant_1_8_2 antLauncher_1_8_2 bsh_2_0_b4 commonsCli_1_2 commonsIo_2_1 commonsLang_2_3 commonsLang_2_6 hamcrestCore_1_3 mavenArtifact_2_0_8 mavenArtifact_3_0_3 mavenCommonArtifactFilters_1_2 mavenCommonArtifactFilters_1_4 mavenDependencyTree_2_1 mavenDoxiaSinkApi_1_0_alpha6 mavenDoxiaSinkApi_1_0_alpha10 mavenEnforcerApi_1_3_1 mavenEnforcerRules_1_3_1 mavenModel_3_0_3 mavenPluginApi_3_0_3 mavenPluginAnnotations_3_2 mavenPluginTestingHarness_1_1 mavenProject_2_0_8 mavenReportingApi_2_2_1 mavenSurefireApi_2_17 mavenSurefireBooter_2_17 mavenSurefireCommon_2_17 mavenToolchain_2_2_1 mojoAnimalSniffer_1_11 mojoJavaBootClasspathDetector_1_11 ow2AsmAll_4_0 plexusArchiver_1_0_alpha7 plexusClassworlds_2_4 plexusI18n_1_0_beta6 plexusUtils_1_0_5 plexusUtils_1_1 plexusUtils_1_4_9 plexusUtils_1_5_6 plexusUtils_2_0_6 sisuGuice_2_9_4 sisuInjectBean_2_1_1 sisuInjectPlexus_2_1_1 xercesImpl_2_8_0 xmlApis_1_3_03 ]
                  ++ (with poms; [ aether_0_9_0_M2 animalSnifferParent_1_11 antParent_1_8_2 apache_1 apache_7 asmParent_4_0 beanshell_2_0_b4 codehausParent_4 commonsParent_11 commonsParent_17 doxia_1_0_alpha6 doxia_1_0_alpha10 enforcer_1_3_1 hamcrestParent_1_3 maven_2_0_1 maven_2_0_8 maven_3_0_3 mavenParent_6 mavenParent_15 mavenPluginTools_3_2 mavenReporting_2_0_1 mavenReporting_2_2_1 mavenSharedComponents_7 mavenSharedComponents_11 mojoParent_32 ow2_1_3 plexus_1_0_12 plexusComponents_1_1_4 plexusComponents_1_1_6 sisuInjectGuiceBean_2_1_1 sisuInject_2_1_1 sisuInjectGuicePlexus_2_1_1 sisuParent_2_1_1 sonatypeForgeParent_7 sonatypeParent_7 surefire_2_17 ]);
    sha512 = "0bbldnf37jl855s1pdx2a518ivfifv75189vsbpylnj8530vnf8z6b2dglkcbcjgr22lp1s4m1nnplz5dmka9sr7vj055p88k27kqw9";
    version = "4.12";
  };
}
