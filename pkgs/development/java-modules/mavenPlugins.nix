{ pkgs, stdenv, lib, maven, fetchurl }:

with pkgs.javaPackages;

let
  mavenbuild = pkgs.callPackage ./build-maven-package.nix { };
  fetchMaven = pkgs.callPackage ./m2install.nix { };
  poms = import ./poms.nix { inherit fetchMaven; };
in rec {
  inherit mavenbuild fetchMaven poms;

  # Standard plugins used by pretty much every Maven build
  mavenDefault = lib.flatten [ aetherUtil_0_9_0_M2 bsh_2_0_b4 classworlds_1_1 commonsCli_1_0 commonsLang_2_3 mavenArtifact_2_0_9 mavenArtifact_3_0_3 mavenArtifactManager_2_0_9 mavenClean_2_5 mavenCommonArtifactFilters_1_4 mavenCompiler_3_1 mavenCore_2_0_9 mavenDependencyTree_2_1 mavenDoxiaSinkApi_1_0_alpha10 mavenEnforcer_1_3_1 mavenEnforcerApi_1_3_1 mavenEnforcerRules_1_3_1 mavenErrorDiagnostics_2_0_9 mavenInstall_2_4 mavenJar_2_4 mavenModel_2_0_9 mavenModel_3_0_3 mavenMonitor_2_0_9 mavenPluginApi_2_0_6 mavenPluginApi_2_0_9 mavenPluginApi_3_0_3 mavenPluginDescriptor_2_0_9 mavenPluginParameterDocumenter_2_0_9 mavenPluginRegistry_2_0_9 mavenProfile_2_0_9 mavenProject_2_0_9 mavenReplacer_1_5_3 mavenReportingApi_2_0_9 mavenRepositoryMetadata_2_0_9 mavenResources_2_6 mavenSettings_2_0_9 mavenSurefire_2_17 plexusComponentAnnotations_1_5_5 plexusContainerDefault_1_0_alpha9_stable1 plexusI18n_1_0_beta6 plexusInteractivityApi_1_0_alpha4 plexusUtils_1_5_8 plexusUtils_2_0_6 plexusUtils_3_0 ] ++ (with poms; [ aether_0_9_0_M2 animalSnifferParent_1_11 apache_10 apache_11 apache_13 apache_3 apache_4 apache_6 beanshell_2_0_b4 codehausParent_4 doxia_1_0_alpha10 doxia_1_0 enforcer_1_3_1 hamcrestParent_1_3 maven_2_0_6 maven_2_0_9 maven_3_0_3 mavenParent_15 mavenParent_21 mavenParent_22 mavenParent_23 mavenParent_5 mavenParent_6 mavenParent_8 mavenPlugins_22 mavenPlugins_23 mavenPlugins_24 mavenReporting_2_0_9 mavenSharedComponents_17 mavenSharedComponents_19 mojoParent_32 plexus_1_0_4 plexus_2_0_2 plexus_2_0_7 plexusComponents_1_1_4 plexusContainers_1_0_3 plexusContainers_1_5_5 sonatypeForgeParent_5 sonatypeParent_7 sonatypeSpiceParent_16 surefire_2_17 ]);

  animalSniffer_1_11 = map (obj: fetchMaven {
    version = "1.11";
    baseName = "animal-sniffer-maven-plugin";
    package = "/org/codehaus/mojo";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "224y5klr8pmm4g3k1qcqrbsjdng1nc9rfzlrk5x50q3d8pn0pj7jr1wg58997m217qimx4pwgcdbgl9niaw0xg136p76kd4hschbxda"; }
    { type = "jar"; sha512 = "24dih4wp7p1rddvxcznlz42yxhqlln5ljdbvwnp75rsyf3ng25zv881ixk5qx8canr1lxx4kh22kwkaahz3qnw54fqn7w5z58m5768n"; }
  ];

  mavenClean_2_5 = map (obj: fetchMaven rec {
    version = "2.5";
    baseName = "maven-clean-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1dc1jd65pz1wl0hr89a8v4g8kd2hcixcdlpa102ffm03mmddc1862whbj9hppx3i3297rahrwl81cph3cdc866fbhbgaj7wld2649n7"; }
    { type = "jar"; sha512 = "2fprppwpmzyvaynadm6slk382khlpf5s8sbi5x249qcaw2vkg5n77q79lgq981v9kjlr5wighjzpjqv8gdig45m2p37mcfwsy3jsv89"; }
  ];

  mavenCompiler_3_1 = map (obj: fetchMaven rec {
    version = "3.1";
    baseName = "maven-compiler-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1dqav3mb4ppg9l10qw04galjmf7yhlyzdna5ldpp3pmpsqglb8m2ab1q324ansz29dbp014w9c7na703jk7qzrja1ilxj0w71rpmsd5"; }
    { type = "jar"; sha512 = "1dvq13yc8yacxr66pkvwwd4cvx0jln8dv9fh5gmd5vir05h8l5j4y324r1bklnzpx0ancs5ad8z944zgmpaq3w195kfsarmndp0gv2y"; }
  ];

  mavenEnforcer_1_3_1 = map (obj: fetchMaven rec {
    version = "1.3.1";
    baseName = "maven-enforcer-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "0w47gx4ksksnl9siq954g2zvx8gx0qa6q5kp91qyyk88c65mfqjjm19613h3dhfmjq9f4rl8b1qhrq35gy7l90aplnibcimrpm6w6nk"; }
    { type = "jar"; sha512 = "15sb9qmxgbq82nzc9x66152va121vf33nn0ah2g4z169cv6jnjq05gk1472k59imypvwsh9hd3hqi9q6g8d0sawgk5l1ax900cx7n25"; }
  ];

  mavenInstall_2_4 = map (obj: fetchMaven rec {
    version = "2.4";
    baseName = "maven-install-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1s5isapjz7mp9cl0jvk8nd1amrasdk257zbil76yabd1h89q4504y01482lxh7sp7x4mcqzj00i6517qcfdzf6w99cnd8dxwgkwqq06"; }
    { type = "jar"; sha512 = "35hbj5hbz085y1dxfmza6m207kn68q2g1k5a9mc75i9pj8fww7xm7xzcdv81xyxjm3r4qbqf1izlg16l99b93rfii9rg8kqz8mxqmb6"; }
  ];

  mavenJar_2_4 = map (obj: fetchMaven rec {
    version = "2.4";
    baseName = "maven-jar-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "12pj3lg7gf0c9hisasrks27b3a0ibvmlbgwbx7p1dcp0as40xwffrx57am7xpqv5bzwl5plh7xxd7s14yyvk8dybjhlj7shqmgn973r"; }
    { type = "jar"; sha512 = "0frbikq8jm5pynlmv51k349kiaipd9jsrh6970313s0g6n4i0ws9vi232wc1mjrc3d27k63xqmb97jzgbbc6q337ypv5vil1ql9wh0d"; }
  ];

  mavenReplacer_1_5_3 = map (obj: fetchMaven rec {
    version = "1.5.3";
    baseName = "replacer";
    package = "/com/google/code/maven-replacer-plugin";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "08vz72v426hd8bzpz2wd003r4kz7rn5syva5picppgwdj69q8xm4dj78mx39ywsgzv2x8jd3w3jpc23pgr07dqj5h2kyj44147lkhsp"; }
    { type = "jar"; sha512 = "0f2rngcxpll0iigv115132fld5n6shjfn7m981sg7mdzlj75q2h5knd4x1ip33w60cm1j0rmqaxp1y6qn76ykvhprdyy9smiy667l9x"; }
  ];

  mavenResources_2_6 = map (obj: fetchMaven rec {
    version = "2.6";
    baseName = "maven-resources-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3rki0dhs3y7w9vbvwf2i7hmq9vismcfq79cdzd3qfs9bva4qxikx939idg8jmwnwaqww4q3wmgwg5vx3n910m8m2xr83x6y0dm62vbk"; }
    { type = "jar"; sha512 = "3j8smsx6wk085iic5qhknrszixxna6szmvk2rn9zkn75ffjr7ham72hw9cmxf5160j73n8f2cmcbw1x462fqy12fqqpmzx08i1sbwcv"; }
  ];

  mavenSurefire_2_17 = map (obj: fetchMaven rec {
    version = "2.17";
    baseName = "maven-surefire-plugin";
    package = "/org/apache/maven/plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "367j67yy8jyq0k7ycnf9ixjy0rl2xb7cz0hwvh9rcbxkbr687bwam2gss0zdsr44q2ndk5hlcq56hhngp055194p90hkcvgr343ng6y"; }
    { type = "jar"; sha512 = "3vhs3djga2ni3bsldn7jml8ya3vgvqaakiybj9y77q8z35xcnf34hsxkmlpm6mbyl5afcv2ij6syas0zppshqbp64ibx7bsqnfi0zbl"; }
  ];
}
