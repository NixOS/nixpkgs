{ stdenv, pkgs, maven }:

with stdenv.lib;
with pkgs.javaPackages;

let
  collections = import ./collections.nix { inherit pkgs; };
  fetchMaven = pkgs.callPackage ./m2install.nix { };
  plugins = import ./mavenPlugins.nix { inherit stdenv pkgs maven; };
  poms = import ./poms.nix { inherit fetchMaven; };
in rec {
  # Maven needs all of these to function
  mavenMinimal = flatten
    collections.mavenLibs_2_0_6
    ++ collections.mavenLibs_2_0_9
    ++ collections.mavenLibs_2_2_1
    ++ [
      classworlds_1_1_alpha2
      classworlds_1_1
      commonsCli_1_0
      commonsLang_2_1
      commonsLang3_3_1
      commonsLoggingApi_1_1
      findbugsJsr305_2_0_1
      googleCollections_1_0
      junit_3_8_1
      junit_3_8_2
      log4j_1_2_12
      mavenArchiver_2_5
      mavenCommonArtifactFilters_1_3
      mavenDoxiaSinkApi_1_0_alpha7
      mavenFiltering_1_1
      mavenPluginAnnotations_3_1
      mavenSharedIncremental_1_1
      mavenSharedUtils_0_1
      mavenSurefireApi_2_12_4
      mavenSurefireBooter_2_12_4
      mavenSurefireCommon_2_12_4
      mavenToolchain_1_0
      mavenToolchain_2_0_9
      plexusArchiver_2_1
      plexusBuildApi_0_0_4
      plexusClassworlds_2_2_2
      plexusCompilerApi_2_2
      plexusCompilerJavac_2_2
      plexusCompilerManager_2_2
      plexusComponentAnnotations_1_5_5
      plexusContainerDefault_1_0_alpha9
      plexusContainerDefault_1_0_alpha9_stable1
      plexusContainerDefault_1_5_5
      plexusDigest_1_0
      plexusInteractivityApi_1_0_alpha4
      plexusInterpolation_1_11
      plexusInterpolation_1_12
      plexusInterpolation_1_13
      plexusInterpolation_1_15
      plexusIo_2_0_2
      plexusUtils_1_0_4
      plexusUtils_1_4_1
      plexusUtils_1_4_5
      plexusUtils_1_5_1
      plexusUtils_1_5_5
      plexusUtils_1_5_8
      plexusUtils_1_5_15
      plexusUtils_2_0_5
      plexusUtils_3_0
      plexusUtils_3_0_5
      plexusUtils_3_0_8
      xbeanReflect_3_4
    ] ++ (with plugins; [
      mavenClean_2_5
      mavenCompiler_3_1
      mavenInstall_2_4
      mavenJar_2_4
      mavenResources_2_6
      mavenSurefire_2_12_4
    ]) ++ (with poms; [
      apache_3
      apache_4
      apache_5
      apache_6
      apache_9
      apache_10
      apache_11
      apache_13
      backportUtilConcurrent_3_1
      commonsParent_22
      doxia_1_0_alpha7
      googleParent_1
      jclOverSlf4j_1_5_6
      maven_2_0_6
      maven_2_0_9
      maven_2_2_1
      mavenParent_5
      mavenParent_8
      mavenParent_11
      mavenParent_13
      mavenParent_21
      mavenParent_22
      mavenParent_23
      mavenPlugins_22
      mavenPlugins_23
      mavenPlugins_24
      mavenPluginTools_3_1
      mavenReporting_2_0_6
      mavenReporting_2_0_9
      mavenSharedComponents_12
      mavenSharedComponents_17
      mavenSharedComponents_18
      mavenSharedComponents_19
      plexus_1_0_4
      plexus_1_0_8
      plexus_1_0_11
      plexus_2_0_2
      plexus_2_0_3
      plexus_2_0_6
      plexus_2_0_7
      plexus_3_0_1
      plexus_3_1
      plexus_3_2
      plexus_3_3_1
      plexusCipher_1_4
      plexusCompiler_2_2
      plexusCompilers_2_2
      plexusComponents_1_1_7
      plexusComponents_1_1_14
      plexusComponents_1_1_15
      plexusComponents_1_1_19
      plexusComponents_1_3_1
      plexusContainers_1_0_3
      plexusContainers_1_5_5
      plexusSecDispatcher_1_3
      slf4jApi_1_5_6
      slf4jJdk14_1_5_6
      slf4jParent_1_5_6
      sonatypeForgeParent_3
      sonatypeForgeParent_4
      sonatypeForgeParent_5
      sonatypeForgeParent_10
      sonatypeSpiceParent_10
      sonatypeSpiceParent_12
      sonatypeSpiceParent_16
      sonatypeSpiceParent_17
      surefire_2_12_4
      xbean_3_4
    ]);
}
